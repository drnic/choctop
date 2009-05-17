Given /^a Cocoa app that does not have an existing Rakefile$/ do
  Given "a safe folder"
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
  Given "a safe folder"
  @remote_folder = File.expand_path(File.join(@tmp_root, 'website'))
  FileUtils.rm_rf   @remote_folder
  FileUtils.mkdir_p @remote_folder
  app_path = File.join(File.dirname(__FILE__), "../fixtures", name)
  `cp -r '#{app_path}' #{@tmp_root}/ 2> /dev/null`
  `rm -rf '#{@tmp_root}/#{name}/build'`
  setup_active_project_folder name
  Given "I run local executable 'install_choctop' with arguments '.'"
  Given "Rakefile wired to use development code instead of installed RubyGem"
  Given "Rakefile constants rewired for local rsync"
  ENV['NO_FINDER'] = 'YES' # disable Finder during tests
end
