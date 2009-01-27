Then /^current xcode project version is '(.*)'$/ do |version|
  in_project_folder do
    ChocTop.new.version.to_s.should == version
  end
end
