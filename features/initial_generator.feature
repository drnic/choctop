Feature: Setup a Cocoa app with sparkle-ruby
  In order to reduce cost of using Sparkle to generate appcasts
  As a Cocoa developer or Cocoa application deployer
  I want a generator to install rake tasks that make using Sparkle easy-peasy
  
  Scenario: Install sparkle-ruby into an app that has no existing Rakefile
    Given a Cocoa app that does not have an existing Rakefile
    When I run local executable 'install_choctop' with arguments '.'
    And Rakefile wired to use development code instead of installed RubyGem
    Then file 'Rakefile' is created
    And output does match /rake appcast:build/
    And output does match /rake appcast:upload/
  
  Scenario: Install sparkle-ruby into an app that has an existing Rakefile
    Given a Cocoa app that does have an existing Rakefile
    When I run local executable 'install_choctop' with arguments '.'
    And Rakefile wired to use development code instead of installed RubyGem
    And output does match /choctop added to your Rakefile/
    And output does match /rake appcast:build/
    And output does match /rake appcast:upload/
  
  Scenario: Run 'install_choctop' without arguments shows an error
    Given a Cocoa app that does not have an existing Rakefile
    When I run local executable 'install_choctop' with arguments ''
    Then output does match /USAGE: install_choctop path\/to\/CocoaApp/
  