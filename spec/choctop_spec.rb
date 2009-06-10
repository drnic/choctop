require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe ChocTop do
  attr_reader :choctop
  
  describe "default" do
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
  
  describe "add_files" do
    before(:each) do
      FileUtils.chdir(File.dirname(__FILE__) + "/../features/fixtures/SampleApp") do
        @choctop = ChocTop.new
        @choctop.add_file "README.txt", :position => [50, 100]
      end
    end
    
    it "should have build/Release/SampleApp.app as a file/bundle" do
      @choctop.files.keys.should be_include('build/Release/SampleApp.app')
    end

    it "should have README.txt as a file" do
      @choctop.files.keys.include?('README.txt')
    end

    it "should have README.txt position" do
      @choctop.files['README.txt'][:position].should == [50, 100]
    end

    describe "+ prepare_files" do
      before(:each) do
        FileUtils.chdir(File.dirname(__FILE__) + "/../features/fixtures/SampleApp") do
          @choctop.prepare_files
        end
      end

      it "should have SampleApp.app in build/Release/dmg ready for inclusion in DMG" do
        FileUtils.chdir(File.dirname(__FILE__) + "/../features/fixtures/SampleApp") do
          File.should be_exists('build/Release/dmg/SampleApp.app')
        end
      end
      
      it "should position SampleApp.app at [175, 65]" do
        @choctop.set_position_of_files.should =~ /set position of item "SampleApp.app" to \{175, 65\}/
      end

      it "should have README.txt in build/Release ready for inclusion in DMG" do
        FileUtils.chdir(File.dirname(__FILE__) + "/../features/fixtures/SampleApp") do
          File.should be_exists('build/Release/dmg/README.txt')
        end
      end
      
      it "should position README.txt at [50, 100]" do
        @choctop.set_position_of_files.should =~ /set position of item "README.txt" to \{50, 100\}/
      end
    end

  end
end
