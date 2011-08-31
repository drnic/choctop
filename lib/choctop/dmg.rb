module ChocTop
  module Dmg
    def codesign_executable
      sh "codesign -v -s '#{codesign_identity}' '#{build_products}/#{name}.app'"
      # this next step just provides the new codesigning info for confirmation
      sh "codesign -dv '#{build_products}/#{name}.app'"
    end
    
    def prepare_files
      self.files = files.inject({}) do |files, file|
        path_or_helper, options = file
        path = case path_or_helper
          when Symbol
            send path_or_helper
          when Proc
            path_or_helper.call
          else
            path_or_helper
        end
        if path && File.exists?(path)
          files[path] = options 
          options[:name] ||= File.basename(path)
        end
        if path =~ %r{\.webloc$}
          files[path] = options 
          options[:name] ||= File.basename(path)
          options[:link] = true
        end
        files
      end
    end

    # Two-phase copy: first to a tmp folder (to prevent recursion); then tmp folder to +dmg_src_folder+
    def copy_files
      FileUtils.mkdir_p(tmp_dmg_src_folder)
      files.each do |path, options|
        if options[:link]
          add_link_to_dmg_src_folder(path, options)
        else
          add_file_to_dmg_src_folder(path, options)
        end
      end
      FileUtils.rm_r(dmg_src_folder) if File.exists? dmg_src_folder
      FileUtils.mkdir_p(dmg_src_folder)
      Dir["#{tmp_dmg_src_folder}/*"].each { |f| FileUtils.cp_r(f, dmg_src_folder) }
    end

    def make_dmg
      codesign_executable if codesign_identity
      prepare_files
      copy_files
      FileUtils.mkdir_p build_path
      FileUtils.mkdir_p mountpoint # TODO can we remove random mountpoints?
      FileUtils.rm_f(pkg) # make sure destination pkg doesn't already exist, or hdiutil will barf
      sh "hdiutil create -format UDRW -quiet -volname '#{name}' -srcfolder '#{dmg_src_folder}' '#{pkg}'"
      mount_dmg
      sh "bless --folder '#{volume_path}' --openfolder '#{volume_path}'"
      sh "sleep 1"

      puts "volume_icon: #{volume_icon.inspect}"
      puts "include_applications_icon?: #{include_applications_icon?.inspect}"
      configure_volume_icon
      configure_applications_icon if include_applications_icon?
      configure_dmg_window
    end
    
    def mount_dmg
      sh "hdiutil attach '#{pkg}' -mountpoint '#{volume_path}' -noautoopen -quiet"
    end

    def volume_background
      ".background/background#{File.extname(background_file)}"
    end

    def window_position
      [50, 100]
    end

    def window_bounds
      window_position + 
      window_position.zip(background_bounds).map { |w, b| w + b }
    end

    def background_bounds
      return [400, 300] unless background_file
      background = OSX::NSImage.alloc.initByReferencingFile(background_file).size.to_a
      [background.first, background.last + statusbar_height]
    end

    def statusbar_height; 20; end

    def configure_volume_icon
      if volume_icon
        FileUtils.cp(volume_icon, "#{volume_path}/.VolumeIcon.icns")
        sh "SetFile -a C '#{volume_path}'"
      end
    end

    def configure_dmg_window
      if background_file
        target_background = "#{volume_path}/#{volume_background}"
        FileUtils.mkdir_p(File.dirname(target_background))
        FileUtils.cp(background_file, target_background) 
      end
      script = <<-SCRIPT.gsub(/^      /, '')
        tell application "Finder"
           set applications_folder to displayed name of (path to applications folder) -- i18n
           set mountpoint to POSIX file ("#{volume_path}" as string) as alias
           tell folder mountpoint
               open
               tell container window
                  set toolbar visible to false
                  set statusbar visible to false -- doesn't do anything at DMG open time
                  set current view to icon view
                  delay 1 -- Sync
                  set the bounds to {#{window_bounds.join(", ")}}
               end tell
               delay 1 -- Sync
               set icon size of the icon view options of container window to #{icon_size}
               set text size of the icon view options of container window to #{icon_text_size}
               set arrangement of the icon view options of container window to not arranged
               #{set_position_of_files}
               #{set_position_of_shortcuts}
               close
               open
               set the bounds of the container window to {#{window_bounds.join(", ")}}
               set background picture of the icon view options of container window to file "#{volume_background.gsub(/\//,':')}"
               update without registering applications
               delay 5 -- Sync
               close
           end tell
           -- Sync
           delay 5
        end tell
      SCRIPT
      puts "script: #{script}"
      run_applescript(script)
      sh "SetFile -a V '#{target_background}'" if background_file
    end

    def set_position_of_files
      files.map do |file_options|
        path, options = file_options
        target        = options[:name]
        position      = options[:position].join(", ")
        %Q{set position of item "#{target}" to {#{position}}}
      end.join("\n")
    end

    def set_position_of_shortcuts
      if include_applications_icon?
        %Q{set position of item applications_folder to {#{applications_icon_position.join(", ")}}}
      else
        ""
      end
    end

    def include_applications_icon?
      target =~ /.app$/
    end

    def configure_applications_icon
      run_applescript <<-SCRIPT.gsub(/^      /, ''), "apps_icon_script"
        tell application "Finder"
          set applications_folder to displayed name of (path to applications folder) -- i18n
          set dest to disk "#{name}"
          set src to folder applications_folder of startup disk
          make new alias at dest to src
        end tell
      SCRIPT
      if applications_icon
        applications_path = "#{volume_path}/Applications"
        OSX::NSApplicationLoad()
        image = OSX::NSImage.alloc.initWithContentsOfFile(applications_icon)
        OSX::NSWorkspace.sharedWorkspace.setIcon_forFile_options(image, applications_path, nil)
      end
    end

    def detach_dmg
      mounted_paths = `hdiutil info | grep '#{volume_path}' | grep "Apple_HFS"`.split("\n").map { |e| e.split(" ").first }
      mounted_paths.each do |path|
        begin
          sh "hdiutil detach '#{path}' -quiet -force"
        rescue StandardError => e
          p e
        end
      end
    end

    def convert_dmg_readonly
      tmp_path = "/tmp/rw.dmg"
      FileUtils.mv(pkg, tmp_path)
      sh "hdiutil convert '#{tmp_path}' -format UDZO -imagekey zlib-level=9 -o '#{pkg}'"
    end

    def add_eula
      # TODO support EULA
      # hdiutil unflatten $@
    	# /Developer/Tools/DeRez -useDF SLAResources.rsrc > build/temp/sla.r
    	# /Developer/Tools/Rez -a build/temp/sla.r -o $@
    	# hdiutil flatten $@
	
    end
    
    def add_file_to_dmg_src_folder(path, options)
      target = File.join(tmp_dmg_src_folder, options[:name])
      sh ::Escape.shell_command(['cp', '-r', path, target])
      if options[:exclude]
        exclude_list = options[:exclude].is_a?(Array) ? options[:exclude] : [options[:exclude].to_s]
        exclude_list.each { |exclude| sh ::Escape.shell_command(['rm', '-rf', File.join(target, exclude)]) }
      end
    end

    def add_link_to_dmg_src_folder(path, options)
      plist_name   = options[:name].gsub(/\.webloc$/, '')
      plist_target = File.join(tmp_dmg_src_folder, plist_name)
      target       = File.join(tmp_dmg_src_folder, options[:name])
      sh ::Escape.shell_command(['defaults', 'write', plist_target, 'URL', options[:url]])
      sh ::Escape.shell_command(['plutil', '-convert', 'xml1', '-o', target, "#{plist_target}.plist"])
      sh ::Escape.shell_command(['rm', "#{plist_target}.plist"])
    end
    
    def run_applescript(applescript, tmp_file = "choctop-script")
      File.open(scriptfile = "/tmp/#{tmp_file}", "w") do |f|
        f << applescript
      end
      sh("osascript #{scriptfile}") do |ok, res|
        if ! ok
          p res
          puts volume_path
          exit 1
        end
      end
      applescript
    end
    
    def tmp_dmg_src_folder
      @tmp_dmg_src_folder ||= begin
        require 'tmpdir'
        File.join(Dir.tmpdir, Time.now.to_i.to_s) # probably unique folder
      end
    end
  end
end
