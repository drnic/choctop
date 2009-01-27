module ChocTop::Dmg
  def make_dmg
    FileUtils.rm_rf pkg
    sh "hdiutil create -format UDRW -quiet -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{pkg}'"
    sh "hdiutil attach '#{pkg}' -mountpoint '#{volume_path}' -noautoopen -quiet"
    sh "ln -s /Applications '#{volume_path}/Applications'"
    target_background = "#{volume_path}/background#{File.extname(background_file)}"
    if background_file
      FileUtils.cp(background_file, target_background) 
      sh "SetFile -a V #{target_background}"
    end
  end
  
  def make_design_dmg
    FileUtils.mkdir_p design_path
    FileUtils.rm_rf design_pkg
    detach_dmg
    sh "hdiutil create -quiet -format UDRW -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{design_pkg}'"
    sh "hdiutil attach '#{design_pkg}' -mountpoint '#{volume_path}' -noautoopen -quiet"
    sh "ln -s /Applications '#{volume_path}/Applications'"
    clone_design_to_volume

    unless ENV['NO_FINDER']
      sh "open #{volume_path} -a Finder"
      puts "Opening your DMG for editing."
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
  
end
ChocTop.send(:include, ChocTop::Dmg)

