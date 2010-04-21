Feature: Rake tasks are available to build and deploy Cocoa apps with Sparkle
  In order to reduce time and cost of deploying Sparkle-enabled Cocoa apps
  As a Cocoa developer or Cocoa application deployer
  I want rake tasks to build and deploy my Cocoa app

  Scenario: rake task to build Release of app
    Given a Cocoa app with choctop installed called "SampleApp"
    When I invoke task "rake build"
    Then folder "build/Release/SampleApp.app" is created

  Scenario: rake task to create dmg file of build
    Given a Cocoa app with choctop installed called "SampleApp"
    When I invoke task "rake dmg"
    Then file "appcast/build/SampleApp-0.1.0.dmg" is created

  Scenario: rake task to bump the major version number
    Given a Cocoa app with choctop installed called "SampleApp"
    When I invoke task "rake version:bump:major"
    Then current xcode project version is "1.0.0"

  Scenario: rake task to bump the minor version number
    Given a Cocoa app with choctop installed called "SampleApp"
    When I invoke task "rake version:bump:minor"
    Then current xcode project version is "0.2.0"

  Scenario: rake task to bump the minor version number
    Given a Cocoa app with choctop installed called "SampleApp"
    When I invoke task "rake version:bump:patch"
    Then current xcode project version is "0.1.1"
  