require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe ChocTop do
  attr_reader :choctop
  
  before(:each) do
    FileUtils.chdir(File.dirname(__FILE__) + "/../features/fixtures/SampleApp") do
      @choctop = ChocTop.new
    end
  end
  
  it "should get name from Info.plist['CFBundleExecutable']" do
    choctop.name.should == 'SampleApp'
  end

  it "should get version from Info.plist['CFBundleVersion']" do
    choctop.version.should == '0.1.0'
  end

  it "should derive host from Info.plist['SUFeedURL']" do
    choctop.host.should == 'mocra.com'
  end
  
  it "should derive base_url from Info.plist['SUFeedURL']" do
    choctop.base_url.should == 'http://mocra.com/sample_app'
  end
  
  it "should derive appcast_filename from Info.plist['SUFeedURL']" do
    choctop.appcast_filename.should == 'my_feed.xml'
  end
  
end
