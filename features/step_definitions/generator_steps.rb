Given /^a Cocoa app that does not have an existing Rakefile$/ do
  setup_active_project_folder "SampleApp"
end

Given /^a Cocoa app that does have an existing Rakefile$/ do
  Given "a Cocoa app that does not have an existing Rakefile"
  in_project_folder do
    File.open("Rakefile", "w") do |f|
      f << <<-RUBY.gsub(/^      /, '')
      require "rubygems"
      require "rake"
      RUBY
    end
  end
end

Given /Rakefile wired to use development code instead of installed RubyGem/ do
  in_project_folder do
    prepend_to_file "Rakefile", "$:.unshift('#{@lib_path}')"
  end
end

Given /Rakefile constants rewired for local rsync/ do
end

Given /^a Cocoa app with choctop installed called "(.*)"$/ do |name|
  @remote_folder = File.expand_path(File.join(@tmp_root, 'website'))
  FileUtils.rm_rf   @remote_folder
  FileUtils.mkdir_p @remote_folder
  app_path = File.join(File.dirname(__FILE__), "../fixtures", name)
  `cp -r '#{app_path}' #{@tmp_root}/ 2> /dev/null`
  `rm -rf '#{@tmp_root}/#{name}/build'`
  setup_active_project_folder name
  Given %Q{I run local executable "install_choctop" with arguments "."}
  Given "Rakefile wired to use development code instead of installed RubyGem"
  Given "Rakefile constants rewired for local rsync"
  ENV['NO_FINDER'] = 'YES' # disable Finder during tests
end

Given /^a non\-Xcode chcotop project "([^\"]*)" with files: (.*)$/ do |name, files|
  files = files.strip.split(/\s*,\s*/)
  setup_active_project_folder name
  Given %Q{I run local executable "install_choctop" with arguments "."}
  Given "Rakefile wired to use development code instead of installed RubyGem"
  Given "Rakefile constants rewired for local rsync"
  ENV['NO_FINDER'] = 'YES' # disable Finder during tests
  in_project_folder do
    files.each { |file| `touch #{file}` }
  end
  files.each { |file| choctop_add_file(file) }
end

Given /^a TextMate bundle project "([^"]*)"$/ do |name|
  app_path = File.join(File.dirname(__FILE__), "../fixtures", name)
  `cp -r '#{app_path}' #{@tmp_root}/ 2> /dev/null`
  `rm -rf '#{@tmp_root}/#{name}/build'`
  setup_active_project_folder name
  steps <<-CUCUMBER
    Given I run local executable "install_choctop" with arguments "."
    Given Rakefile wired to use development code instead of installed RubyGem
  CUCUMBER
  ENV['NO_FINDER'] = 'YES' # disable Finder during tests
  choctop_add_root
end

Given /^I want a link "([^"]*)" to "([^"]*)" in the DMG$/ do |name, url|
  choctop_add_link name, url
end


