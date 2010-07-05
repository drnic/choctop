# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{choctop}
  s.version = "0.12.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dr Nic Williams", "Chris Bailey", "Patrick Huesler"]
  s.date = %q{2010-07-05}
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
    rake build               # Build Xcode Release
    rake dmg                 # Create the dmg file for appcasting
    rake feed                # Create/update the appcast file
    rake upload              # Upload the appcast file to the host
    rake version:bump:major  # Bump the gemspec by a major version.
    rake version:bump:minor  # Bump the gemspec by a minor version.
    rake version:bump:patch  # Bump the gemspec by a patch version.
    rake version:current     # Display the current version}
  s.email = ["drnicwilliams@gmail.com", "chris@cobaltedge.com", "patrick.huesler@gmail.com"]
  s.executables = ["install_choctop"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "features/fixtures/SampleApp/README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "app_generators/install_choctop/install_choctop_generator.rb", "app_generators/install_choctop/templates/Rakefile.erb", "app_generators/install_choctop/templates/release_notes.txt.erb", "app_generators/install_choctop/templates/release_notes_template.html.erb", "assets/DefaultVolumeIcon.icns", "assets/sky.jpg", "assets/sky_background.jpg", "assets/vanillia_dmg_icon.png", "assets/wood.jpg", "bin/install_choctop", "choctop.gemspec", "features/development.feature", "features/dmg.feature", "features/fixtures/App With Whitespace/App With Whitespace.xcodeproj/TemplateIcon.icns", "features/fixtures/App With Whitespace/App With Whitespace.xcodeproj/project.pbxproj", "features/fixtures/App With Whitespace/App With Whitespace_Prefix.pch", "features/fixtures/App With Whitespace/English.lproj/InfoPlist.strings", "features/fixtures/App With Whitespace/English.lproj/MainMenu.xib", "features/fixtures/App With Whitespace/Info.plist", "features/fixtures/App With Whitespace/main.m", "features/fixtures/SampleApp/English.lproj/InfoPlist.strings", "features/fixtures/SampleApp/English.lproj/MainMenu.xib", "features/fixtures/SampleApp/Info.plist", "features/fixtures/SampleApp/README.txt", "features/fixtures/SampleApp/SampleApp.xcodeproj/TemplateIcon.icns", "features/fixtures/SampleApp/SampleApp.xcodeproj/project.pbxproj", "features/fixtures/SampleApp/SampleApp_Prefix.pch", "features/fixtures/SampleApp/main.m", "features/fixtures/custom_assets/appicon.icns", "features/initial_generator.feature", "features/rake_tasks.feature", "features/sparkle_feed.feature", "features/step_definitions/common_steps.rb", "features/step_definitions/dmg_steps.rb", "features/step_definitions/file_attribute_steps.rb", "features/step_definitions/generator_steps.rb", "features/step_definitions/remote_steps.rb", "features/step_definitions/xcode_steps.rb", "features/support/common.rb", "features/support/dmg_helpers.rb", "features/support/env.rb", "features/support/matchers.rb", "lib/choctop.rb", "lib/choctop/appcast.rb", "lib/choctop/dmg.rb", "lib/choctop/rake_tasks.rb", "lib/choctop/version_helper.rb", "script/console", "script/destroy", "script/generate", "spec/choctop_spec.rb", "spec/dmg_spec.rb", "spec/fixtures/Info.plist", "spec/spec.opts", "spec/spec_helper.rb", "spec/version_helper_spec.rb"]
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
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.1"])
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0.beta"])
      s.add_development_dependency(%q<cucumber>, ["= 0.8.3"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<hoe>, [">= 2.6.1"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<rspec>, [">= 2.0.0.beta"])
      s.add_dependency(%q<cucumber>, ["= 0.8.3"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<hoe>, [">= 2.6.1"])
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<rspec>, [">= 2.0.0.beta"])
    s.add_dependency(%q<cucumber>, ["= 0.8.3"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
  end
end
