Given /^dmg has a custom design$/ do
  FileUtils.chdir("/Volumes/SampleApp") do
    # create a .DS_Store
    `touch .DS_Store`
    # add a background.png
    `touch background.png`
  end
end
