Feature: Generate an XML file for Sparkle to use for updates
  In order to reduce cost of distributing apps to users
  As a developer/release manager
  I want to generate an XML file for the Sparkle framework
  
  Scenario: rake task to create/update the appcast file
    Given a Cocoa app with choctop installed
    And ChocTop config is configured for remote Sparkle
    When task 'rake feed' is invoked
    Then file 'appcast/build/my_feed.xml' is created
    And contents of file 'appcast/build/my_feed.xml' does match /<channel>/
    And contents of file 'appcast/build/my_feed.xml' does match /</channel>/
    And contents of file 'appcast/build/my_feed.xml' does match /<pubDate>/
    And contents of file 'appcast/build/my_feed.xml' does match /<item>/
    And contents of file 'appcast/build/my_feed.xml' does match /<title>SampleApp 0.1.0</title>/
    And contents of file 'appcast/build/my_feed.xml' does match /href="http://mocra.com/sample_app/my_feed.xml"/
    And contents of file 'appcast/build/my_feed.xml' does match /<sparkle:releaseNotesLink>http://mocra.com/sample_app/release_notes.html</sparkle:releaseNotesLink>/
    And file 'appcast/build/index.php' is created
    And contents of file 'appcast/build/index.php' does match /Location/
    And contents of file 'appcast/build/index.php' does match /SampleApp-0.1.0.dmg/
  
  

  
