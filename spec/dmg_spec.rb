require File.dirname(__FILE__) + '/spec_helper.rb'

describe ChocTop::Dmg do
  before(:each) do
    @project_path = File.dirname(__FILE__) + "/../features/fixtures/SampleApp"
    FileUtils.chdir(@project_path) do
      @choctop = ChocTop::Configuration.new
      @choctop.files = {}
    end
  end

  context "#prepare_files" do
    it "should process :readme into a path" do
      FileUtils.chdir(@project_path) do
        @choctop.file :readme, :position=>[175, 65]
        @choctop.prepare_files
        @choctop.files['README.txt'].should == {:position=>[175, 65], :name => 'README.txt'}
      end
    end

    it "should process procs into a path" do
      FileUtils.chdir(@project_path) do
        @choctop.file proc { 'README.txt' }, :position=>[175, 65]
        @choctop.prepare_files
        @choctop.files['README.txt'].should == {:position=>[175, 65], :name => 'README.txt'}
      end
    end

    it "should process blocks into a path" do
      FileUtils.chdir(@project_path) do
        @choctop.file(:position => [175, 65]) { 'README.txt' }
        @choctop.prepare_files
        @choctop.files['README.txt'].should == {:position=>[175, 65], :name => 'README.txt'}
      end
    end
  end
  
  context "#link" do
    it "should take args: .link(url, name, :position => [x,y])" do
      FileUtils.chdir(@project_path) do
        @choctop.link('http://github.com', 'Fork me', :position => [175, 65])
        @choctop.prepare_files
        @choctop.files['Fork me.webloc'].should == {
          :position=>[175, 65], :url => 'http://github.com', :name => 'Fork me.webloc', :link => true
        }
      end
    end

    it "should take args: .link(url, :name => 'Name.webloc', :position => [x,y])" do
      FileUtils.chdir(@project_path) do
        @choctop.link('http://github.com', :name => 'Fork me.webloc', :position => [175, 65])
        @choctop.prepare_files
        @choctop.files['Fork me.webloc'].should == {
          :position=>[175, 65], :url => 'http://github.com', :name => 'Fork me.webloc', :link => true
        }
      end
    end
  end
end