$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "fileutils"
require "rubygems"
require "builder"
require "active_support"

class Choctop
  VERSION = '0.9.0'
  
  # The name of the Cocoa application
  attr_accessor :name
  
  # The host name, e.g. some-domain.com
  attr_accessor :host
  
  # The url from where the xml + zip files will be downloaded
  # Default: http://#{host}
  attr_accessor :base_url
  
  # The name of the local xml file containing the Sparkle item details
  # Default: linker_appcast.xml
  attr_accessor :appcast_filename
  
  # The remote directory where the xml + zip files will be rsync'd
  attr_accessor :remote_dir
  
  # The argument flags passed to rsync
  # Default: -aCv
  attr_accessor :rsync_args
  
  def initialize(name)
    $sparkle = self # define a global variable for this object
    @name = name
    
    # Defaults
    @appcast_filename = 'linker_appcast.xml'
    @rsync_args = '-aCv'
    
    yield self if block_given?

    @base_url ||= "http://#{host}"
    
    define_tasks
    
  end

  def define_tasks
    namespace :appcast do
      desc "Create/update the appcast file"
      task :build do
        make_appcast
      end

      desc "Upload the appcast file to the host"
      task :upload do
        upload_appcast
      end
    end
  end
end
require "choctop/appcast"

