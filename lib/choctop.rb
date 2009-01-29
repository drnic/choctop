$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "fileutils"
require "yaml"
require "builder"
require "erb"
require "osx/cocoa"
require "active_support"
require "RedCloth"

class ChocTop
  VERSION = '0.9.2'
  
  # The name of the Cocoa application
  # Default: info_plist['CFBundleExecutable'] or project folder name if "${EXECUTABLE}"
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
  attr_writer :base_url
  def base_url
    @base_url ||= "http://#{host}"
  end
  
  # The file name for generated release notes for the latest release
  # Default: release_notes.html
  attr_accessor :release_notes

  # The path for an HTML template into which the ReleaseNotes.txt are inserted
  # after conversion to HTML
  #
  # The template file is an ERb template, with <%= yield %> as the placeholder
  # for the generated release notes.
  #
  # Currently, any CSS or JavaScript must be inline
  #
  # Default: a choctop supplied HTML template for release notes
  attr_accessor :release_notes_template

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
  
  # Path to generated package DMG
  def pkg
    "#{build_path}/#{pkg_name}"
  end
  
  # Path to built DMG, sparkle's xml file and other assets to be uploaded to remote server
  def build_path
    "appcast/build"
  end
  
  def mountpoint
    # @mountpoint ||= "/tmp/build/mountpoint#{rand(10000000)}"
    @mountpoint ||= "/Volumes"
  end
  
  # Path to Volume when DMG is mounted
  def volume_path
    "#{mountpoint}/#{name}"
  end
  
  #
  # Custom DMG properties
  #
  
  # Path to background .icns image file for custom DMG
  # Value should be file path relative to root of project
  # Default: a choctop supplied background image
  # that matches to default app_icon_position + applications_icon_position
  # To have no custom background, set value to +nil+
  attr_accessor :background_file
  
  # x, y position of this project's icon on the custom DMG
  # Default: a useful position for the icon against the default background
  attr_accessor :app_icon_position
  
  # x, y position of the Applications symlink icon on the custom DMG
  # Default: a useful position for the icon against the default background
  attr_accessor :applications_icon_position
  
  # Path to an .icns file for the DMG's volume icon (looks like a disk or drive)
  # Default: a DMG icon provided within choctop
  # To get default, boring blank DMG volume icon, set value to +nil+
  attr_accessor :volume_icon
  
  # Size of icons, in pixels, within custom DMG (between 16 and 128)
  # Default: 104 - this is nice and big
  attr_accessor :icon_size
  
  # The url for the remote package, without the protocol + host
  # e.g. if absolute url is http://mydomain.com/downloads/MyApp-1.0.dmg
  # then pkg_relative_url is /downloads/MyApp-1.0.dmg
  def pkg_relative_url
    _base_url = base_url.gsub(%r{/$}, '')
    "#{_base_url}/#{pkg_name}".gsub(%r{^.*#{host}}, '')
  end
  
  def info_plist
    @info_plist ||= OSX::NSDictionary.dictionaryWithContentsOfFile(File.expand_path('Info.plist')) || {}
  end
  
  def initialize
    $sparkle = self # define a global variable for this object
    
    # Defaults
    @name = info_plist['CFBundleExecutable']
    @name = File.basename(File.expand_path(".")) if name == "${EXECUTABLE}"
    @version = info_plist['CFBundleVersion']
    @target = "#{name}.app"
    @appcast_filename = info_plist['SUFeedURL'] ? File.basename(info_plist['SUFeedURL']) : 'linker_appcast.xml'
    @release_notes = 'release_notes.html'
    @release_notes_template = File.dirname(__FILE__) + "/../assets/release_notes_template.html.erb"
    @rsync_args = '-aCv --progress'
    
    @background_file = File.dirname(__FILE__) + "/../assets/sky_background.jpg"
    @app_icon_position = [175, 65]
    @applications_icon_position = [347, 270]
    @volume_icon = File.dirname(__FILE__) + "/../assets/DefaultVolumeIcon.icns"
    @icon_size = 104
    
    yield self if block_given?

    define_tasks
  end
  
  def define_tasks
    return unless Object.const_defined?("Rake")
    
    desc "Build Xcode Release"
    task :build => "build/Release/#{target}/Contents/Info.plist"
    
    task "build/Release/#{target}/Contents/Info.plist" do
      make_build
    end
    
    desc "Create the dmg file for appcasting"
    task :dmg => :build do
      detach_dmg
      make_dmg
      detach_dmg
      convert_dmg_readonly
      add_eula
    end
    
    desc "Create/update the appcast file"
    task :feed do
      make_appcast
      make_index_redirect
      make_release_notes
    end
    
    desc "Upload the appcast file to the host"
    task :upload => :feed do
      upload_appcast
    end

    desc "Create dmg, update appcast file, and upload to host"
    task :appcast => %w[force_build dmg force_feed upload]
    
    task :detach_dmg do
      detach_dmg
    end
    
    task :size do
      puts configure_dmg_window
    end
  end
end
require "choctop/appcast"
require "choctop/dmg"

