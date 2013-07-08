#!/bin/zsh -f
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2013-02-26
#
#	NOTE: In order for this script to work, the following lines must be added to /etc/sudoers (without the leading '#' of course)
#
#	%admin ALL=NOPASSWD: /bin/launchctl list
#	%admin ALL=NOPASSWD: /bin/launchctl load /Library/LaunchDaemons/com.crashplan.engine.plist
# 	%admin ALL=NOPASSWD: /bin/launchctl unload /Library/LaunchDaemons/com.crashplan.engine.plist

NAME="$0:t"

PLIST='/Library/LaunchDaemons/com.crashplan.engine.plist’

	# if the file doesn't exist, stop right there
[[ -e "$PLIST" ]] || exit 0


GROWL_APP='CrashPlan'

msg () {
	STICKY=""
	DIE='no'

	for ARGS in "$@"
	do
		case "$ARGS" in
			-s|--sticky)
				STICKY=--sticky
				shift
			;;

			-d|--die)
				DIE=yes
				STICKY=--sticky
				shift
			;;
		esac
	done

	MSG="$@"

	ps cx | egrep -q ' Growl$' || open -g -a Growl 2>/dev/null

	ps cx | egrep -q ' Growl$' && \
	(( $+commands[growlnotify] )) && growlnotify --appIcon "$APPNAME" --identifier "${NAME}.$$" ${STICKY} --message "$MSG" "$NAME"

	echo "$NAME: $MSG"

	[[ "$DIE" = "yes" ]] && exit 1
}

launch_menu_bar_app () {

if [ "`ps cx | egrep ' CrashPlan menu bar$'`" = "" ]
then
		# the CrashPlan menu bar is NOT running

		msg "Telling CrashPlan menu bar app to launch"

		open -a "CrashPlan menu bar"
fi

}

launch_menu_bar_app

	# Get a list of all of root's loaded plists
ROOT_LOADED=$(sudo launchctl list)

if [[ "$ROOT_LOADED" == "" ]]
then
			# if we didn't get anything in response, die ugly
		msg --die "ROOT_LOADED is empty"
		exit 1
fi

	# if we got this far, we did get some response from ROOT_LOADED

echo "$ROOT_LOADED" | fgrep -q com.crashplan.engine

EXIT="$?"

if [[ "$EXIT" = "0" ]]
then
			# If we get here then crashplan IS loaded
			# so we exit because this is what we wanted
		msg "CrashPlan already loaded"

		launch_menu_bar_app

		exit 0

else
			# if we get here, crashplan is not loaded
			# so we'll try to load it and exit if successful
		EXIT=1
		sudo /bin/launchctl load "$PLIST" && EXIT=0

		if [ "$EXIT" = "0" ]
		then
				msg "Loaded crashplan plist successfully"

					# When running, I want the menu bar also running
				launch_menu_bar_app

		else
				msg --die "Failed to Load plist"
		fi

		exit $EXIT

fi

	# If we get here, something unexpected happened
exit 2

#
#EOF
