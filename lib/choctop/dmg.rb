module ChocTop::Dmg
  def make_dmg
    FileUtils.rm_rf pkg
    sh "hdiutil create -quiet -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{pkg}'"
  end
  
  def make_design_dmg
    FileUtils.mkdir_p design_path
    FileUtils.rm_rf design_pkg
    detach_dmg
    sh "hdiutil create -format UDRW -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{design_pkg}' -quiet"
    sh "hdiutil attach '#{design_pkg}' -mountpoint '#{volume_path}' -noautoopen -quiet"
    sh "ln -s /Applications '#{volume_path}/Applications'"
  end
  
  def store_dmg_design
    FileUtils.cp "#{volume_path}/.DS_Store", "#{design_path}/ds_store" rescue nil
    %w[jpg png gif].each do |image_type|
      puts "cp #{volume_path}/*.#{image_type} #{design_path}/"
      FileUtils.cp "#{volume_path}/*.#{image_type}", "#{design_path}/" rescue nil
    end
    true
  end
  
  def detach_dmg
    mounted_paths = `hdiutil info | grep '#{volume_path}' | grep "Apple_HFS"`.split("\n").map { |e| e.split(" ").first }
    mounted_paths.each do |path|
      sh "hdiutil detach '#{path}' -quiet -force"
    end
  end
  
end
ChocTop.send(:include, ChocTop::Dmg)

