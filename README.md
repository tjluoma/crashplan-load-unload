crashplan-load-unload
=====================

Shell scripts to load or unload CrashPlan on Mac OS X


## Background ##

In [Mac Power Users 145: Keyboard Maestro Turns 6], [Katie Floyd] was looking for a way to automatically pause and un-pause CrashPlan and Dropbox at the start/end of her podcasting sessions.  She also wanted to set her Google Voice to Do-Not-Disturb. 

Well, the short answer is "no" for all three.

1. There's no API at all for Google Voice, so as far as I know there's no way to set the Google Voice to DND.

2. Although the Dropbox client for Linux has had a command-line tool for years, the Mac client does not, and it is not scriptable unless you want to try to script selecting stuff on the menu bar. Which is a horrible idea. Don't do that. It won't work. The only *automatic* thing you can do for Dropbox is quit it and restart it, which stinks because Dropbox is horribly inefficient at startup time. Pausing is much better if you can do it. But you can't automate it. 

3. There is no way to 'pause' CrashPlan via script -- as far as I know.

That's the bad news. There is *some* good news.

1. You can pop up a notification reminder to turn your Google Voice to DND and then use your iPhone app to do that while the rest of the macro is running.

2. You can (pretty easily) tell Dropbox to quit at the start of your podcasting and restart when it is over.

3. Likewise, you can tell CrashPlan to start/stop when your podcasting session starts/ends.

### How I recommend doing this ###

I wrote about this a bit [on TUAW back in March]. At that time I recommended using an AppleScript to pause CrashPlan:

	do shell script "launchctl unload /Library/LaunchDaemons/com.crashplan.engine.plist" with administrator privileges

The administrator privileges are necessary because the CrashPlan launchd entry is owned by root.

I *also* suggested pausing Time Machine in a similar way:

	do shell script "tmutil disable" with administrator privileges

(I then showed how to reverse those at the end of the podcasting session. You can find the [GitHub repo here] 

### What Keyboard Maestro "trigger" should you use. ###

Katie really likes the USB actions in Keyboard Maestro, and for good reason -- they're cool. But, like [David], I use my USB microphone for more than just podcasting. 

However, I don't use Skype *except* when I'm podcasting, and really, the reason that we're turning off these things is that they're going to interfere with *Skype.* So I run my triggers off of Skype launching or quitting.

## Included in this Repo are two scripts to load or unload CrashPlan 

I use these with Keyboard Maestro for when I need to load/unload CrashPlan without entering my password.

How did I manage that? Simple, I added these lines to `/etc/sudoers`:

	%admin ALL=NOPASSWD: /bin/launchctl list
	
	%admin ALL=NOPASSWD: /bin/launchctl load /Library/LaunchDaemons/com.crashplan.engine.plist
	
	%admin ALL=NOPASSWD: /bin/launchctl unload /Library/LaunchDaemons/com.crashplan.engine.plist

*be sure to use `visudo` to make any changes to the `sudoers` file!*

The scripts will work even if you don't add those lines to /etc/sudoers, but they will prompt the user for her/his `sudo` password, which means that they will only work if you launch them in Terminal/iTerm/etc. If you want to be able to use these scripts with Keyboard Maestro or `launchd` then you will ned to add the lines to your `shudders` file.

### For the occasional podcaster...

As someone who only records a podcast every other week or so, I find it much easier to use a separate Mac OS X login account than trying to "undo" all of the things which can cause distractions during a podcast recording.

I created a second 'administrator' account on my Mac, and loaded it only with the apps that I use for podcasting. Skype will auto-launch, Dropbox won't. Time Machine is not configured. iMessage is not configured. No email or Twitter accounts are configured. I have no `launchd` processes or Keyboard Maestro time-triggers on that account.

However, since CrashPlan is run by root, I still need to load/unload it when I log into that account


### A devious Dropbox idea ###

As I was writing this up, I realized that there _is_ a way to pause/un-pause Dropbox. It's **not** a very _good_ way, but it's _a_ way. You can find it at <https://github.com/tjluoma/dropbox-pause-unpause>.

<!-- Reference Links -->


[on TUAW back in March]: http://www.tuaw.com/2013/03/12/keyboard-maestro-before-and-after-skype-podcasting/ 

[Katie Floyd]: http://www.katiefloyd.me/

[Mac Power Users 145: Keyboard Maestro Turns 6]: http://www.macpowerusers.com/2013/07/07/mac-power-users-145-keyboard-maestro-turns-6/

[GitHub repo here]: https://github.com/tjluoma/keyboard-maestro-for-podcasts

[David]: http://www.macsparky.com/

