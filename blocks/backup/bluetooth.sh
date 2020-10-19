#!/usr/bin/env bash

source "$(dirname $0)/_colors.sh"

# echo '📶'
# echo '📶'
echo ''
echo ''
# echo ''
# echo ''

if [[ `bluetoothctl show | grep Powered | awk '{print $2}'` = 'yes' ]]; then
    echo "$BLUE"
else
    echo "$BLACK"
fi
