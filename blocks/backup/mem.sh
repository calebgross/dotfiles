#!/usr/bin/env bash

source "$(dirname $0)/_colors.sh"
source "$(dirname $0)/meminfo.sh"

MEM=$(getmem)

echo "📚 $MEM"
echo "📚 $MEM"
if [[ "$MEM" < 1 ]]; then
    echo "$RED"
elif [[ "$MEM" < 2 ]]; then
    echo "$YELLOW"
else
    echo
fi
