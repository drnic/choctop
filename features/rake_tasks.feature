Feature: Rake tasks are available to build and deploy Cocoa apps with Sparkle
  In order to reduce time and cost of deploying Sparkle-enabled Cocoa apps
  As a Cocoa developer or Cocoa application deployer
  I want rake tasks to build and deploy my Cocoa app

  Scenario: rake task to create/update the appcast file
    Given a Cocoa app with choctop installed
    And a zip build has been created
    When task 'rake appcast:build' is invoked
    Then file 'appcast/build/linker_appcast.xml' is created
    And contents of file 'appcast/build/linker_appcast.xml' does match /<channel>/
    And contents of file 'appcast/build/linker_appcast.xml' does match /</channel>/
    And contents of file 'appcast/build/linker_appcast.xml' does match /<pubDate>/
    And contents of file 'appcast/build/linker_appcast.xml' does match /<item>/
    And contents of file 'appcast/build/linker_appcast.xml' does match /<title>myapp 1.0.0</title>/
  
  Scenario: rake task to upload the appcast file to the server
    Given a Cocoa app with choctop installed
    And task 'rake appcast:build' is invoked
    And Choctop config is configured for local rsync
    When task 'rake appcast:upload' is invoked
    Then remote file 'linker_appcast.xml' is created
    Then remote file 'Myapp-1.0.0.zip' is created
  
