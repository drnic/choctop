require 'spec_helper'

describe ChocTop::VersionHelper do
  before(:each) do
    @version_helper = ChocTop::VersionHelper.new(File.expand_path("spec/fixtures/Info.plist"))
  end
  
  it "should handle Xcodes default format d.d" do
    @version_helper.to_s.should == "1.0.0"
  end
  
  it "should bump major" do
    @version_helper.bump_major
    @version_helper.to_s.should == "2.0.0"
  end
  
  it "should bump minor" do
    @version_helper.bump_minor
    @version_helper.to_s.should == "1.1.0"
  end
  
  it "should bump patch" do
    @version_helper.bump_patch
    @version_helper.to_s.should == "1.0.1"
  end
end
