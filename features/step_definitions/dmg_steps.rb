Given /is configured for custom Applications icon$/ do
  appicon = File.expand_path(File.dirname(__FILE__) + "/../fixtures/custom_assets/appicon.icns")
  in_project_folder do
    append_to_file "Rakefile", <<-RUBY.gsub(/^    /, '')
    $sparkle.applications_icon = "appicon.icns"
    RUBY
    FileUtils.cp(appicon, "appicon.icns")
  end
end

When /^dmg "(.*)" is mounted as "(.*)"$/ do |dmg, name|
  @stdout = File.expand_path(File.join(@tmp_root, "hdiutil.out"))
  in_project_folder do
    @mountpoint = ChocTop.new.mountpoint
    FileUtils.mkdir_p @mountpoint
    @volume_path = "#{@mountpoint}/#{name}"
    `hdiutil attach '#{dmg}' -mountpoint '#{@volume_path}' -noautoopen > #{@stdout}`
  end
end

def in_mounted_volume(&block)
  FileUtils.chdir(@volume_path, &block)
end

Then %r{^folder "(.*)" in mounted volume (is|is not) created} do |folder, is|
  in_mounted_volume do
    File.exists?(folder).should(is == 'is' ? be_true : be_false)
  end
end

Then %r{^file "(.*)" in mounted volume (is|is not) created} do |file, is|
  in_mounted_volume do
    File.exists?(file).should(is == 'is' ? be_true : be_false)
  end
end

Then /^file "(.*)" in mounted volume (is|is not) invisible$/ do |file, is|
  in_mounted_volume do
    `GetFileInfo -aV '#{@volume_path}/#{file}'`.to_i.should_not == (is == 'is' ? 0 : 1)
  end
end

