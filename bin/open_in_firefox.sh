#!/bin/bash
#
# Source: https://gist.github.com/SpotlightKid/25feb97350bef923f14b42321b6e7ec4
#
# open-in-firefox.sh - open URL from Termux command line in Firefox Android browser
#
# Works with file:// URLs too, unlike with termux-open{-url}.
#

exec am start --user 0 -a android.intent.action.VIEW -n org.mozilla.firefox/.App -d "$1" >/dev/null
