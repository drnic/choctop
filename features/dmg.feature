Feature: Can build a customised DMG image from application build
  In order to reduce cost of building DMG images for each release of an application
  As a Cocoa developer or release manager
  I want a rake task to generate a DMG based on custom settings

  Scenario: Build a DMG with default custom DMG config
    Given a Cocoa app with choctop installed called 'SampleApp'
    When task 'rake dmg' is invoked
    Then file 'appcast/build/SampleApp-0.1.0.dmg' is created
    When dmg 'appcast/build/SampleApp-0.1.0.dmg' is mounted as 'SampleApp'
    Then folder 'SampleApp.app' in mounted volume is created
    And file 'Applications' in mounted volume is created
    And file '.background/background.jpg' in mounted volume is created
    And file '.background/background.jpg' in mounted volume is invisible
    And file '.VolumeIcon.icns' in mounted volume is created

  Scenario: Build a DMG with a whitespace name
    Given a Cocoa app with choctop installed called 'App With Whitespace'
    When task 'rake dmg' is invoked
    Then file 'appcast/build/App With Whitespace-1.0.dmg' is created
    When dmg 'appcast/build/App With Whitespace-1.0.dmg' is mounted as 'App With Whitespace'
    Then folder 'App With Whitespace.app' in mounted volume is created
    And file 'Applications' in mounted volume is created
    And file '.background/background.jpg' in mounted volume is created
    And file '.background/background.jpg' in mounted volume is invisible
    And file '.VolumeIcon.icns' in mounted volume is created

  Scenario: Build a DMG with custom Applications symlink icon
    Given a Cocoa app with choctop installed called 'SampleApp'
    And is configured for custom Applications icon
    When task 'rake dmg' is invoked
    And dmg 'appcast/build/SampleApp-0.1.0.dmg' is mounted as 'SampleApp'
    Then folder 'SampleApp.app' in mounted volume is created
    And file 'Applications' in mounted volume is created
    And file 'appicon.icns' in mounted volume is created
    And file 'appicon.icns' in mounted volume is invisible
