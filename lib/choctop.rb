$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "fileutils"
require "yaml"
require "rubygems"
require "builder"
require "active_support"
require "osx/cocoa"

class Choctop
  VERSION = '0.9.0'
  
  # The name of the Cocoa application
  # Default: info_plist['CFBundleExecutable']
  attr_accessor :name
  
  # The version of the Cocoa application
  # Default: info_plist['CFBundleVersion']
  attr_accessor :version
  
  # The target name of the distributed DMG file
  # Default: #{name}.app
  attr_accessor :target
  
  # The host name, e.g. some-domain.com
  attr_accessor :host
  
  # The url from where the xml + dmg files will be downloaded
  # Default: http://#{host}
  attr_accessor :base_url
  
  # The name of the local xml file containing the Sparkle item details
  # Default: info_plist['SUFeedURL'] or linker_appcast.xml
  attr_accessor :appcast_filename
  
  # The remote directory where the xml + dmg files will be rsync'd
  attr_accessor :remote_dir
  
  # The argument flags passed to rsync
  # Default: -aCv
  attr_accessor :rsync_args
  
  # Generated filename for a distribution, from name, version and .dmg
  # e.g. MyApp-1.0.0.dmg
  def pkg_name
    "#{name}-#{version}.dmg"
  end
  
  # Path to generated package file
  def pkg
    "appcast/build/#{pkg_name}"
  end
  
  def info_plist
    @info_plist ||= OSX::NSDictionary.dictionaryWithContentsOfFile(File.expand_path('Info.plist'))
  end
  
  def version_info
    begin
      YAML.load_file("appcast/version_info.yml")
    rescue Exception => e
      raise StandardError, "appcast/version_info.yml could not be loaded: #{e.message}"
    end
  end
  
  def initialize
    $sparkle = self # define a global variable for this object
    
    # Defaults
    @name = info_plist['CFBundleExecutable']
    @version = info_plist['CFBundleVersion']
    @target = "#{name}.app"
    @appcast_filename = info_plist['SUFeedURL'] ? File.basename(info_plist['SUFeedURL']) : 'linker_appcast.xml'
    @rsync_args = '-aCv'
    
    yield self if block_given?

    @base_url ||= "http://#{host}"
    
    define_tasks
  end

  def define_tasks
    namespace :appcast do
      desc "Build Xcode Release"
      task :build => "build/Release/#{target}/Contents/Info.plist"
      
      task "build/Release/#{target}/Contents/Info.plist" do
        make_build
      end
      
      desc "Create the dmg file for appcasting"
      task :dmg => "appcast/build/#{pkg_name}"
      
      file "appcast/build/#{pkg_name}" => "build/Release/#{target}/Contents/Info.plist" do
        make_dmg
      end
      
      desc "Create/update the appcast file"
      task :feed => "appcast/build/#{appcast_filename}"
      
      file "appcast/build/#{appcast_filename}" => "appcast/build/#{pkg_name}" do
        make_appcast
      end        

      desc "Upload the appcast file to the host"
      task :upload do
        upload_appcast
      end
    end
    
    desc "Create dmg, update appcast file, and upload to host"
    task :appcast => %w[appcast:build appcast:feed appcast:upload]
  end
end
require "choctop/appcast"

