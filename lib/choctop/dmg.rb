module ChocTop::Dmg
  def prepare_files
    FileUtils.mkdir_p(src_folder)
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
      files[path] = options if File.exists?(File.join(path))
      files
    end
  end
  
  def copy_files
    files.each do |file|
      path, options = file
      FileUtils.cp_r(path, src_folder)
    end
  end
  
  def make_dmg
    prepare_files
    copy_files
    FileUtils.mkdir_p build_path
    FileUtils.mkdir_p mountpoint # TODO can we remove random mountpoints?
    sh "hdiutil create -format UDRW -quiet -volname '#{name}' -srcfolder '#{src_folder}' '#{pkg}'"
    sh "hdiutil attach '#{pkg}' -mountpoint '#{volume_path}' -noautoopen -quiet"
    sh "bless --folder '#{volume_path}' --openfolder '#{volume_path}'"
    sh "sleep 1"

    puts "volume_icon: #{volume_icon.inspect}"
    puts "include_applications_icon?: #{include_applications_icon?.inspect}"
    configure_volume_icon
    configure_applications_icon if include_applications_icon?
    configure_dmg_window
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
    run_applescript(script)
    sh "SetFile -a V '#{target_background}'" if background_file
  end
  
  def set_position_of_files
    files.map do |file_options|
      path, options = file_options
      target        = File.basename(path)
      position      = options[:position].join(", ")
      %Q{set position of item "#{target}" to {#{position}}}
    end.join("\n")
  end
  
  def set_position_of_shortcuts
    if include_applications_icon?
      %Q{set position of item "Applications" to {#{applications_icon_position.join(", ")}}}
    else
      ""
    end
  end
  
  def include_applications_icon?
    puts "target: #{target.inspect}"
    target =~ /.app$/
  end
  
  def configure_applications_icon
    run_applescript <<-SCRIPT.gsub(/^      /, ''), "apps_icon_script"
      tell application "Finder"
        set dest to disk "#{name}"
        set src to folder "Applications" of startup disk
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
end
ChocTop.send(:include, ChocTop::Dmg)

