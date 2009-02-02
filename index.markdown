---
layout: default
title: ChocTop
---

### Introducing ChocTop

ChocTop packages and deploys any Cocoa application in a custom DMG, with generated Sparkle XML support.

### Screencast

<object width="500" height="375"><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=3049180&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=01AAEA&amp;fullscreen=1" /><embed src="http://vimeo.com/moogaloop.swf?clip_id=3049180&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=01AAEA&amp;fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="500" height="375"></embed></object><br /><a href="http://vimeo.com/3049180">ChocTop - packaging and deployment of Cocoa applications</a> from <a href="http://vimeo.com/user289979">Dr Nic</a> on <a href="http://vimeo.com">Vimeo</a>.

[Download QuickTime Movie](http://www.vimeo.com/download/video:87685244?e=1233561345&amp;h=73e93c78ab63146ed2f460e963bcdb72&amp;uh=ea4240c7d2ca97bf2c67dd997754d4b3) from [Vimeo](http://www.vimeo.com) (275Mb)

### Instructions

ChocTop is a command-line installer plus rake tasks (watch the screencast if this is confusing), bundled
as a RubyGem:

<pre>sudo gem install choctop
install_choctop path/to/xcode/project</pre>

Your project is given a Rakefile, a release\_notes.txt and a release\_notes\_template.html.erb

You edit the Rakefile with your custom DMG asset information and/or remote file locations for the rsync
upload process. CommitChat's Rakefile includes:

<pre lang="ruby">ChocTop.new do |s|
  s.host     = 'commitchat.com'
  s.base_url = 'http://commitchat.com/secret_path_to_beta'
  s.remote_dir = '/opt/apps/commitchat/secret_path_to_beta'
  
  s.background_file = "dmgbg.png"
  s.volume_icon = 'VolumeIcon.icns'
  s.app_icon_position = [106, 83]
  s.applications_icon_position = [422, 83]
end</pre>

You also need to add <a href="http://sparkle.andymatuschak.org/" title="Sparkle: a free software update framework for the Mac">Sparkle</a> 
to your project, and the Info.plist properties such as `SUFeedURL`.

To generate a new DMG, run:

<pre>rake dmg</pre>

To generate a new DMG and push it up to the remote server, and subsequently have users automatically
start downloading the latest + greatest automatically via Sparkle:

<pre>rake dmg upload</pre>

I'm very sorry. It is perhaps too easy. It probably should be harder to make it seem more useful.

The very cool part is that when the DMG is being designed + constructed from your Rakefile settings 
you actually can see it happening on the screen. The AppleScript that is executed
actually operates upon the DMG whilst it is mounted, before unmounting it, compressing and read-only-ifying
it. Its pretty to watch.

### More information

* Homepage - <a href="http://drnic.github.com/choctop">http://drnic.github.com/choctop</a>
* Source - <a href="http://github.com/drnic/choctop" title="drnic's choctop at master - GitHub">http://github.com/drnic/choctop</a>
* Tickets - <a href="http://drnic.lighthouseapp.com/projects/24673-choctop">http://drnic.lighthouseapp.com/projects/24673-choctop</a>
