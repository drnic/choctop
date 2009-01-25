module ChocTop::Dmg
  def make_dmg
    FileUtils.rm_rf pkg
    sh "hdiutil create -quiet -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{pkg}'"
  end
  
  def make_dmg_design
    FileUtils.rm_rf pkg
    sh "hdiutil create -quiet -format UDRW -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{design_pkg}'"
    sh "hdiutil attach '#{design_pkg}' -noautoopen -quiet" #  -noautoopen -- for testing only
  end
  
  
end
ChocTop.send(:include, ChocTop::Dmg)

