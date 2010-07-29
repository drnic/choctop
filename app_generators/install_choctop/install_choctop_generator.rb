class InstallChoctopGenerator < RubiGen::Base
  attr_reader :name, :module_name, :urlname, :version, :github_user

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

      case options[:project_type]
      when :textmate
        m.template "Rakefile.textmate.erb", "Rakefile"
        m.readme "README.textmate"
      else
        m.template "Rakefile.erb", "Rakefile"
        m.template "release_notes.txt.erb", "release_notes.txt"
        m.file "release_notes_template.html.erb", "release_notes_template.html.erb"
        m.readme "README.normal"
      end
    end
  end

  protected
    def banner
      <<-EOS
Installs choctop into your project/Cocoa application. This gives you
rake tasks to build and deploy your project's latest version into a DMG
and for release via Sparkle appcast mechanism.

USAGE: #{spec.name} path/to/project
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
      opts.on("--textmate", "--tmbundle", 
              "Target project is a TextMate bundle",
              "Default: false") { |o| options[:project_type] = :textmate }
      opts.on("-V", "--initial-version", 
              "Set initial version number.",
              "Default: 0.1.0") { |o| options[:version] = o }
    end

    def extract_options
      @version     = options[:version]
      @github_user = options[:github_user]
    end
    
    def self.default_github_user
      `git config github.user || whoami`.strip
    end

  default_options :version => "0.1.0", :github_user => default_github_user

end
