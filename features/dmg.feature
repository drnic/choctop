Feature: Can build a customised DMG image from application build
  In order to reduce cost of building DMG images for each release of an application
  As a Cocoa developer or release manager
  I want a rake task to generate a DMG based on custom settings

  Scenario: Build a vanilla DMG
    Given a Cocoa app with choctop installed
    When task 'rake dmg' is invoked
    Then file 'appcast/build/SampleApp-0.1.0.dmg' is created
    
  Scenario: Build and mount an editable DMG for design purposes
    Given a Cocoa app with choctop installed
    When task 'rake dmg:design' is invoked
    Then file 'appcast/build/SampleApp-design.dmg' is created
    And folder '/Volumes/SampleApp' is created
    And folder '/Volumes/SampleApp/SampleApp.app' is created
    And folder '/Volumes/SampleApp/SampleApp.app' is editable
    And file '/Volumes/SampleApp/Applications' is a symlink to '/Applications'
  
  Scenario: Freezing a designed dmg closes the volume
    Given a Cocoa app with choctop installed
    And task 'rake dmg:design' is invoked
    And folder '/Volumes/SampleApp' is created
    When task 'rake dmg:freeze' is invoked
    Then folder '/Volumes/SampleApp' is not created

  Scenario: Freezing a designed dmg stores its .DS_Store and background
    Given a Cocoa app with choctop installed
    And task 'rake dmg:design' is invoked
    And dmg has a custom design
    When task 'rake dmg:freeze' is invoked
    Then file 'appcast/design/ds_store' is created
    And file 'appcast/design/background.jpg' is created
    And file 'appcast/design/VolumeIcon.icns' is created

  Scenario: Re-designing a DMG will recommence from last freeze point
    Given a Cocoa app with choctop installed
    And task 'rake dmg:design' is invoked
    And dmg has a custom design
    And task 'rake dmg:freeze' is invoked
    When task 'rake dmg:design' is invoked
    Then file '/Volumes/SampleApp/.DS_Store' is created
    And file '/Volumes/SampleApp/background.jpg' is created
    And file '/Volumes/SampleApp/VolumeIcon.icns' is created
    And file '/Volumes/SampleApp/.VolumeIcon.icns' is created and set as volume icon
    
  Scenario: Build a DMG from a design
    Given a Cocoa app with choctop installed
    And task 'rake dmg:design' is invoked
    And dmg has a custom design
    And task 'rake dmg:freeze' is invoked
    When task 'rake dmg' is invoked
    Then file 'appcast/build/SampleApp-0.1.0.dmg' is created
    When volume 'appcast/build/SampleApp-0.1.0.dmg' is mounted as 'SampleApp'
    Then file '/Volumes/SampleApp/.DS_Store' is created
    And file '/Volumes/SampleApp/background.jpg' is created
    And file '/Volumes/SampleApp/.VolumeIcon.icns' is created and set as volume icon
  