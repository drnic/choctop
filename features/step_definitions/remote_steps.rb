Then %r{^remote folder "(.*)" is created} do |folder|
  FileUtils.chdir @remote_folder do
    File.exists?(folder).should be_true
  end
end

Then %r{^remote file "(.*)" (is|is not) created} do |file, is|
  FileUtils.chdir @remote_folder do
    File.exists?(file).should(is == 'is' ? be_true : be_false)
  end
end

Given /^ChocTop config is configured for local rsync$/ do
  in_project_folder do
    append_to_file "Rakefile", <<-RUBY.gsub(/^    /, '')
    $sparkle.host = ""
    $sparkle.remote_dir = #{@remote_folder.inspect}
    RUBY
  end
end

Given /^ChocTop config is configured for remote Sparkle$/ do
  in_project_folder do
    append_to_file "Rakefile", <<-RUBY.gsub(/^    /, '')
    $sparkle.host = "mocra.com"
    $sparkle.base_url = "http://mocra.com/sample_app"
    $sparkle.remote_dir = "/opt/apps/mocra/downloads/sample_app"
    RUBY
  end
end
