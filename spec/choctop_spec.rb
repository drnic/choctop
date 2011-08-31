require File.dirname(__FILE__) + '/spec_helper.rb'

describe ChocTop::Configuration do
  describe "default" do
    before(:each) do
      FileUtils.chdir(File.dirname(__FILE__) + "/../features/fixtures/SampleApp") do
        @choctop = ChocTop::Configuration.new
      end
    end

    it "should get name from Info.plist['CFBundleExecutable']" do
      @choctop.name.should == 'SampleApp'
    end

    it "should get version from Info.plist['CFBundleVersion']" do
      @choctop.version.should == '0.1.0'
    end

    it "should derive host from Info.plist['SUFeedURL']" do
      @choctop.host.should == 'mocra.com'
    end

    it "should derive base_url from Info.plist['SUFeedURL']" do
      @choctop.base_url.should == 'http://mocra.com/sample_app'
    end

    it "should derive appcast_filename from Info.plist['SUFeedURL']" do
      @choctop.appcast_filename.should == 'my_feed.xml'
    end
    
    it "should default the appcast_filename to my_feed.xml" do
      ChocTop::Configuration.new.appcast_filename.should == 'my_feed.xml'
    end
    
    it "should raise an exception if the base_url is nil" do
      lambda{
        ChocTop::Configuration.new.pkg_relative_url
      }.should raise_error(Exception, "The base url should be set in order to create a sparkle feed. Set the SUFeedURL in your Info.plist.")
    end
  end
  
  describe "add_files" do
    before(:each) do
      FileUtils.chdir(File.dirname(__FILE__) + "/../features/fixtures/SampleApp") do
        @choctop = ChocTop::Configuration.new
        @choctop.add_file "README.txt", :position => [50, 100]
      end
    end
    
    it "should have target_bundle as a file/bundle" do
      @choctop.files.keys.should include(:target_bundle)
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
            
      it "should position README.txt at [50, 100]" do
        @choctop.set_position_of_files.should =~ /set position of item "README.txt" to \{50, 100\}/
      end
    end

  end

  describe "add_files for non-Cocoa app" do
    before(:each) do
      @my_project_path = File.dirname(__FILE__) + "/../tmp/MyProject"
      FileUtils.rm_rf(@my_project_path)
      FileUtils.mkdir_p(@my_project_path)
      `touch #{File.join(@my_project_path, 'README.txt')}`
      `touch #{File.join(@my_project_path, 'some_other_file.txt')}`
      FileUtils.chdir(@my_project_path) do
        @choctop = ChocTop::Configuration.new
        @choctop.add_file "README.txt", :position => [50, 100]
        @choctop.add_file "some_other_file.txt", :position => [50, 150]
        @choctop.prepare_files
      end
    end
    
    it "should not render an Applications shortcut" do
      @choctop.set_position_of_shortcuts.should_not =~ /applications_folder/
    end
  end
  
  describe "defaults" do
    before do
      @my_project_path = File.dirname(__FILE__) + "/../tmp/MyProject"
      FileUtils.rm_rf(@my_project_path)
      FileUtils.mkdir_p(@my_project_path)
    end

    describe ":textmate" do
      before do
        FileUtils.chdir(@my_project_path) do
          @choctop = ChocTop::Configuration.new do |s|
            s.defaults :textmate
            s.add_file "README.txt", :position => [0,0]
          end
          @choctop.prepare_files
        end
      end

      it "should have textmate background" do
        @choctop.background_file.should =~ /textmate_background.jpg$/
      end

      it "should have textmate volume icon" do
        @choctop.volume_icon.should =~ /textmate_volume.icns$/
      end
    end

    describe "normal" do
      before do
        FileUtils.chdir(@my_project_path) do
          @choctop = ChocTop::Configuration.new
          @choctop.prepare_files
        end
      end

      it "should have default background" do
        @choctop.background_file.should =~ /default_background.jpg$/
      end

      it "should have default volume icon" do
        @choctop.volume_icon.should =~ /default_volume.icns$/
      end
    end
  end
end
