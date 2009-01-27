Feature: Rake tasks are available to build and deploy Cocoa apps with Sparkle
  In order to reduce time and cost of deploying Sparkle-enabled Cocoa apps
  As a Cocoa developer or Cocoa application deployer
  I want rake tasks to build and deploy my Cocoa app

  Scenario: rake task to build Release of app
    Given a Cocoa app with choctop installed
    When task 'rake build' is invoked
    Then folder 'build/Release/SampleApp.app' is created

  Scenario: rake task to create dmg file of build
    Given an unbuilt Cocoa app with choctop installed
    And task 'rake build' is invoked
    When task 'rake dmg' is invoked
    Then file 'appcast/build/SampleApp-0.1.0.dmg' is created

  Scenario: rake task to create/update the appcast file
    Given a Cocoa app with choctop installed
    When task 'rake feed' is invoked
    Then file 'appcast/build/linker_appcast.xml' is created
    And contents of file 'appcast/build/linker_appcast.xml' does match /<channel>/
    And contents of file 'appcast/build/linker_appcast.xml' does match /</channel>/
    And contents of file 'appcast/build/linker_appcast.xml' does match /<pubDate>/
    And contents of file 'appcast/build/linker_appcast.xml' does match /<item>/
    And contents of file 'appcast/build/linker_appcast.xml' does match /<title>SampleApp 0.1.0</title>/
    And file 'appcast/build/index.php' is created
    And contents of file 'appcast/build/index.php' does match /Location/
    And contents of file 'appcast/build/index.php' does match /SampleApp-0.1.0.dmg/
  
  Scenario: rake task to upload the appcast file to the server
    Given a Cocoa app with choctop installed
    And task 'rake feed' is invoked
    And ChocTop config is configured for local rsync
    When task 'rake upload' is invoked
    Then remote file 'linker_appcast.xml' is created
    Then remote file 'SampleApp-0.1.0.dmg' is created
    Then remote file 'index.php' is created
    
  Scenario: change the version number in the Info.plist
    Given a Cocoa app with choctop installed
    When task 'rake version:set VERSION="1.2.3"' is invoked 
    Then current xcode project version is '1.2.3'
  
  