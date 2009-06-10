Feature: Generate an XML file for Sparkle to use for updates
  In order to reduce cost of distributing apps to users
  As a developer/release manager
  I want to generate an XML file for the Sparkle framework
  
  Scenario: rake task to create/update the appcast file
    Given a Cocoa app with choctop installed called "SampleApp"
    And ChocTop config is configured for remote Sparkle
    When I invoke task "rake dmg feed"
    Then file "appcast/build/my_feed.xml" is created
    And file "appcast/build/my_feed.xml" contents does match /<channel>/
    And file "appcast/build/my_feed.xml" contents does match /</channel>/
    And file "appcast/build/my_feed.xml" contents does match /<pubDate>/
    And file "appcast/build/my_feed.xml" contents does match /<item>/
    And file "appcast/build/my_feed.xml" contents does match /<title>SampleApp 0.1.0</title>/
    And file "appcast/build/my_feed.xml" contents does match /href="http://mocra.com/sample_app/my_feed.xml"/
    And file "appcast/build/my_feed.xml" contents does match /<sparkle:releaseNotesLink>http://mocra.com/sample_app/release_notes.html</sparkle:releaseNotesLink>/
    And file "appcast/build/index.php" is created
    And file "appcast/build/index.php" contents does match /Location/
    And file "appcast/build/index.php" contents does match /SampleApp-0.1.0.dmg/
    And file "appcast/build/release_notes.html" is created
    And file "appcast/build/release_notes.html" contents does match /0.1.0/
    And file "appcast/build/release_notes.html" contents does match /<h2>Initial release</h2>/
    And file "appcast/build/release_notes.html" contents does match /<p>Yay! First release.</p>/
    And file "appcast/build/release_notes.html" contents does match /<html>/
  
  Scenario: generate default release notes if no release_notes.txt
    Given a Cocoa app with choctop installed called "SampleApp"
    And ChocTop config is configured for remote Sparkle
    And "release_notes.txt" file is deleted
    When I invoke task "rake dmg feed"
    Then file "appcast/build/release_notes.html" is created
    And file "appcast/build/release_notes.html" contents does match /0.1.0/
    And file "appcast/build/release_notes.html" contents does match /<h2>Initial release</h2>/
    And file "appcast/build/release_notes.html" contents does match /<html>/



