module ChocTop::Dmg
  def make_dmg
    FileUtils.rm_rf pkg
    sh "hdiutil create -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{pkg}'"
  end
  
  def make_writeable_dmg
    FileUtils.rm_rf pkg
    sh "hdiutil create -format UDRW -volname '#{name}' -srcfolder 'build/Release/#{target}' '#{pkg}'"
  end
  
  
end
ChocTop.send(:include, ChocTop::Dmg)

