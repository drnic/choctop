$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

class SparkleTools
  VERSION = '0.0.1'
  
  attr_accessor :name
  attr_accessor :server
  attr_accessor :base_url
  attr_accessor :appcast_filename
  attr_accessor :remote_dir
  attr_accessor :rsync_args
  
  def initialize(name)
    $sparkle = self # define a global variable for this object
    @name = name
    
    # Defaults
    @appcast_filename = 'linker_appcast.xml'
    @rsync_args = '-av'
    
    yield self if block_given?

    @base_url ||= "http://#{server}"
    
    define_tasks
    
  end

  def define_tasks
    namespace :appcast do
      desc "Create/update the appcast file"
      task :build do
        make_appcast
      end

      desc "Upload the appcast file to the server"
      task :upload do
        upload_appcast
      end
    end
  end
end
require "sparkle_tools/appcast"

require "fileutils"
require "builder"

require "rubygems"
require "active_support"