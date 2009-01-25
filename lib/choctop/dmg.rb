module ChocTop::Dmg
  def make_dmg
    FileUtils.rm_rf pkg
    sh "hdiutil create -quiet -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{pkg}'"
  end
  
  def make_dmg_design
    FileUtils.rm_rf pkg
    sh "hdiutil create -quiet -format UDRW -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{design_pkg}'"
    sh "hdiutil attach '#{design_pkg}' -mountpoint '/Volumes/#{name}' -noautoopen -quiet" #  TODO -noautoopen -- for testing only; cloak this in ENV variable
    sh "ln -s /Applications '/Volumes/#{name}/Applications'"
  end
  
  
end
ChocTop.send(:include, ChocTop::Dmg)

