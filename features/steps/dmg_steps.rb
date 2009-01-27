When /^dmg '(.*)' is mounted as '(.*)'$/ do |dmg, name|
  @stdout = File.expand_path(File.join(@tmp_root, "hdiutil.out"))
  in_project_folder do
    `hdiutil attach '#{dmg}' -mountpoint '/Volumes/#{name}' -noautoopen > #{@stdout}`
    File.should be_exist("/Volumes/#{name}")
  end
end
