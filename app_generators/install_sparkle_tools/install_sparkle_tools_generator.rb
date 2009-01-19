class InstallSparkleToolsGenerator < RubiGen::Base
  attr_reader :name, :module_name, :version

  default_options :version => "1.0.0"

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @name = base_name
    @module_name = base_name.gsub(/[-]+/, '_').camelcase
    extract_options
  end

  def manifest
    record do |m|
      %w( appcast/build ).each { |path| m.directory path }

      m.file     "Rakefile",         "Rakefile", :collision => :skip
      m.template "appcast/version_info.yml.erb",  "appcast/version_info.yml"
    end
  end

  protected
    def banner
      <<-EOS
Installs sparkle_tools into your Cocoa application. This gives you
rake tasks to build and deploy your Cocoa app's latest version for
Sparkle appcast mechanism.

USAGE: #{spec.name} path/to/CocoaApp
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
      opts.on("-V", "--initial-version", 
              "Show the #{File.basename($0)} version number and quit.",
              "Default: 1.0.0") { |o| options[:version] = o }
    end

    def extract_options
      @version = options[:version]
    end
end