require File.dirname(__FILE__) + '/spec_helper.rb'

describe ChocTop::Dmg do
  attr_reader :choctop
  
  before(:each) do
    @project_path = File.dirname(__FILE__) + "/../features/fixtures/SampleApp"
    FileUtils.chdir(@project_path) do
      @choctop = ChocTop.new
      @choctop.files = {}
    end
  end

  context "#prepare_files" do
    it "should process :target_bundle into a path" do
      FileUtils.chdir(@project_path) do
        @choctop.file :readme, :position=>[175, 65]
        @choctop.prepare_files
        @choctop.files['README.txt'].should == {:position=>[175, 65]}
      end
    end

    it "should process procs into a path" do
      FileUtils.chdir(@project_path) do
        @choctop.file proc { 'README.txt' }, :position=>[175, 65]
        @choctop.prepare_files
        @choctop.files['README.txt'].should == {:position=>[175, 65]}
      end
    end

    it "should process blocks into a path" do
      FileUtils.chdir(@project_path) do
        @choctop.file(:position => [175, 65]) { 'README.txt' }
        @choctop.prepare_files
        @choctop.files['README.txt'].should == {:position=>[175, 65]}
      end
    end
  end
end