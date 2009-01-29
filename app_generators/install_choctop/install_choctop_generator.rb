class InstallChoctopGenerator < RubiGen::Base
  attr_reader :name, :module_name, :urlname, :version

  default_options :version => "0.1.0"

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @name        = base_name
    @module_name = name.gsub(/[-]+/, '_').camelcase
    @urlname     = name.gsub(/[-_]+/, '').downcase
    extract_options
  end

  def manifest
    record do |m|
      %w( appcast/build ).each { |path| m.directory path }

      m.template "Rakefile.erb", "Rakefile"
      m.template "release_notes.txt.erb", "release_notes.txt"
      m.file "release_notes_template.html.erb", "release_notes_template.html.erb"
    end
  end

  protected
    def banner
      <<-EOS
Installs choctop into your Cocoa application. This gives you
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
              "Default: 0.1.0") { |o| options[:version] = o }
    end

    def extract_options
      @version = options[:version]
    end
end