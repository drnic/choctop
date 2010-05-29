# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{choctop}
  s.version = "0.11.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dr Nic Williams", "Chris Bailey"]
  s.date = %q{2010-05-29}
  s.default_executable = %q{install_choctop}
  s.description = %q{Build and deploy tools for Cocoa apps using Sparkle for distributions and upgrades; 
it’s like Hoe but for Cocoa apps.

Package up your OS X/Cocoa applications into Custom DMGs, generate Sparkle XML, and
upload. Instead of hours, its only 30 seconds to release each new version of an application.

Build and deploy tools for Cocoa apps using Sparkle for distributions and upgrades; it's
like Hoe but for Cocoa apps.

The main feature is a powerful rake task "rake appcast" which builds a release of your
application, creates a DMG package, generates a Sparkle XML file, and posts the package
and XML file to your remote host via rsync.

All rake tasks:

    rake appcast         # Create dmg, update appcast file, and upload to host
    rake build   # Build Xcode Release
    rake dmg     # Create the dmg file for appcasting
    rake feed    # Create/update the appcast file
    rake upload  # Upload the appcast file to the host}
  s.email = ["drnicwilliams@gmail.com", "chris@cobaltedge.com"]
  s.executables = ["install_choctop"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "app_generators/install_choctop/install_choctop_generator.rb", "app_generators/install_choctop/templates/Rakefile.erb", "app_generators/install_choctop/templates/release_notes.txt.erb", "app_generators/install_choctop/templates/release_notes_template.html.erb", "assets/DefaultVolumeIcon.icns", "assets/sky.jpg", "assets/sky_background.jpg", "assets/vanillia_dmg_icon.png", "assets/wood.jpg", "bin/install_choctop", "features/development.feature", "features/dmg.feature", "features/fixtures/custom_assets/appicon.icns", "features/initial_generator.feature", "features/rake_tasks.feature", "features/sparkle_feed.feature", "features/step_definitions/common_steps.rb", "features/step_definitions/dmg_steps.rb", "features/step_definitions/file_attribute_steps.rb", "features/step_definitions/generator_steps.rb", "features/step_definitions/remote_steps.rb", "features/step_definitions/xcode_steps.rb", "features/support/common.rb", "features/support/env.rb", "features/support/matchers.rb", "lib/choctop.rb", "lib/choctop/appcast.rb", "lib/choctop/dmg.rb", "lib/choctop/rake_tasks.rb", "lib/choctop/version_helper.rb", "script/console", "script/destroy", "script/generate", "spec/choctop_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.homepage = %q{http://drnic.github.com/choctop}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{choctop}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Build and deploy tools for Cocoa apps using Sparkle for distributions and upgrades;  it’s like Hoe but for Cocoa apps}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<newgem>, [">= 1.5.3"])
      s.add_dependency(%q<hoe>, [">= 2.6.0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<newgem>, [">= 1.5.3"])
    s.add_dependency(%q<hoe>, [">= 2.6.0"])
  end
end
