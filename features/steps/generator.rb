Given /^a Cocoa app that does not have an existing Rakefile$/ do
  Given "a safe folder"
  setup_active_project_folder "myapp"
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
    force_local_lib_override
  end
end
