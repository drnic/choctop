Then /^current xcode project version is "(.*)"$/ do |version|
  in_project_folder do
    ChocTop::Configuration.new.version.to_s.should == version
  end
end
