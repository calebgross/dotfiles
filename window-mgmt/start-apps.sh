#!/bin/bash

DIRNAME=$(dirname "$0")
notify() { osascript -e 'display notification "'"$1"'" with title "'"Start Apps"'"'; }

##
# Start apps.
##

notify 'Starting Firefox'
source "$DIRNAME/../.bashrc.d/"*"-browser.sh"
fpa

for APP in \
'Übersicht' \
'Microsoft Outlook' \
'Microsoft Teams' \
'Slack' \
; do
    if ! [[ $(pgrep -f "$APP.app") ]]; then
        notify "Starting $APP"
        open -a "$APP"
    fi
done

##
# Organize windows.
##

sleep 10
"$DIRNAME/organize-windows.sh"
