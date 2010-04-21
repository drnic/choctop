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