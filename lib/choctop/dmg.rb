module ChocTop::Dmg
  def make_dmg
    FileUtils.rm_rf pkg
    sh "hdiutil create -format UDRW -quiet -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{pkg}'"
    sh "hdiutil attach '#{pkg}' -mountpoint '#{volume_path}' -noautoopen -quiet"
    sh "ln -s /Applications '#{volume_path}/Applications'"
    if background_file
      target_background = "#{volume_path}/background#{File.extname(background_file)}"
      FileUtils.cp(background_file, target_background) 
      sh "SetFile -a V #{target_background}"
    end
    if volume_icon
      FileUtils.cp(volume_icon, "#{volume_path}/.VolumeIcon.icns")
      sh "SetFile -a C #{volume_path}"
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
    FileUtils.cp(pkg, tmp_path)
    sh "hdiutil convert '#{tmp_path}' -format UDZO -imagekey zlib-level=9 -o '#{pkg}'"
  end
  
  def add_eula
    # TODO support EULA
    # hdiutil unflatten $@
  	# /Developer/Tools/DeRez -useDF SLAResources.rsrc > build/temp/sla.r
  	# /Developer/Tools/Rez -a build/temp/sla.r -o $@
  	# hdiutil flatten $@
  	
  end
end
ChocTop.send(:include, ChocTop::Dmg)

