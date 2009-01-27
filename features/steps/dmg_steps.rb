Given /^dmg has a custom design$/ do
  volume_path = "/Volumes/SampleApp"
  # Create a .DS_Store and add a background.jpg
  FileUtils.cp(File.dirname(__FILE__) + "/../fixtures/design/ds_store", volume_path)
  FileUtils.cp(File.dirname(__FILE__) + "/../fixtures/design/background.jpg", volume_path)
end

When /^volume '(.*)' is mounted as '(.*)'$/ do |dmg, name|
  `hdiutil attach '#{dmg}' -mountpoint '/Volumes/#{name}' -noautoopen -quiet`
end
