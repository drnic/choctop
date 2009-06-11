Feature: Can build a customised DMG image from application build
  In order to reduce cost of building DMG images for each release of an application
  As a Cocoa developer or release manager
  I want a rake task to generate a DMG based on custom settings

  Scenario: Build a DMG with default custom DMG config
    Given a Cocoa app with choctop installed called "SampleApp"
    When I invoke task "rake dmg"
    Then file "appcast/build/SampleApp-0.1.0.dmg" is created
    When dmg "appcast/build/SampleApp-0.1.0.dmg" is mounted as "SampleApp"
    Then folder "SampleApp.app" in mounted volume is created
    And file "Applications" in mounted volume is created
    And file ".background/background.jpg" in mounted volume is created
    And file ".background/background.jpg" in mounted volume is invisible
    And file ".VolumeIcon.icns" in mounted volume is created

  Scenario: Build a DMG with a whitespace name
    Given a Cocoa app with choctop installed called "App With Whitespace"
    When I invoke task "rake dmg"
    Then file "appcast/build/App With Whitespace-1.0.dmg" is created
    When dmg "appcast/build/App With Whitespace-1.0.dmg" is mounted as "App With Whitespace"
    Then folder "App With Whitespace.app" in mounted volume is created
    And file "Applications" in mounted volume is created
    And file ".background/background.jpg" in mounted volume is created
    And file ".background/background.jpg" in mounted volume is invisible
    And file ".VolumeIcon.icns" in mounted volume is created

  Scenario: Build a DMG with custom Applications symlink icon
    Given a Cocoa app with choctop installed called "SampleApp"
    And is configured for custom Applications icon
    When I invoke task "rake dmg"
    And dmg "appcast/build/SampleApp-0.1.0.dmg" is mounted as "SampleApp"
    Then file "Applications" in mounted volume is created
    And file "Applications" in mounted volume has GetFileInfo type ""fdrp""
    And file "Applications" in mounted volume has GetFileInfo alias "1"
    And file "Applications" in mounted volume has GetFileInfo custom icon "1"
    And file "Applications" in mounted volume is aliased to "/Applications"
  
  Scenario: Build a DMG with extra included file such as README in the project folder
    Given a Cocoa app with choctop installed called "SampleApp"
    And is configured for an asset file "README.txt" to be included in dmg
    When I invoke task "rake dmg"
    And dmg "appcast/build/SampleApp-0.1.0.dmg" is mounted as "SampleApp"
    And file "README.txt" in mounted volume is created
    And file "SampleApp.app.dSYM" in mounted volume is not created

  Scenario: Build a DMG for non-Xcode project
    Given a non-Xcode chcotop project "MyProject" with files: README.txt, SomeBundle.thingy
    When I invoke task "rake dmg"
    And dmg "appcast/build/MyProject.dmg" is mounted as "MyProject"
    And file "README.txt" in mounted volume is created
    And file "SomeBundle.thingy" in mounted volume is created
    And file "Applications" in mounted volume is not created
