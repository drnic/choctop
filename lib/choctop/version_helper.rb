class VersionHelper
  attr_accessor :info_plist_path
  attr_reader :major, :minor, :patch, :build
  
  def initialize(info_plist_path)
    self.info_plist_path = info_plist_path
    parse_version
    if block_given?
      yield self
      write
    end
  end
  
  def info_plist
    @info_plist ||= OSX::NSDictionary.dictionaryWithContentsOfFile(File.expand_path(info_plist_path)) || {}
  end
  
  def parse_version
    # http://rubular.com/regexes/10467 -> 3.5.4.a1
    # http://rubular.com/regexes/10468 -> 3.5.4
    # regex on nsstring is broken so convert it to a ruby string
    if  info_plist['CFBundleVersion'].to_s =~ /^(\d+)\.(\d+)\.(\d+)(?:\.(.*?))?$/
      @major = $1.to_i
      @minor = $2.to_i
      @patch = $3.to_i
      @build = $4
    end
  end

  def bump_major
    @major += 1
    @minor = 0
    @patch = 0
    @build = nil
  end

  def bump_minor
    @minor += 1
    @patch = 0
    @build = nil
  end

  def bump_patch
    @patch += 1
    @build = nil
  end

  def update_to(major, minor, patch, build=nil)
    @major = major
    @minor = minor
    @patch = patch
    @build = build
  end
  
  def write
    info_plist['CFBundleVersion'] =  to_s
    info_plist['CFBundleShortVersionString'] = to_s
    info_plist.writeToFile_atomically(File.expand_path(info_plist_path),true)
  end

  def to_s
    [major, minor, patch, build].compact.join('.')
  end
end