#!/bin/bash

alias yabai=/usr/local/bin/yabai
get_displays() { yabai -m query --displays; }
get_windows()  { yabai -m query --windows;  }
get_display_index() { echo "$DISPLAY" | jq '.index';      }
get_space_index()   { echo "$DISPLAY" | jq ".spaces[$1]"; }

# This function takes relative space/display arrangement indices, determines
# the absolute index for those values, and moves windows accordingly.
# For example:
# - "move_window Firefox 0 0"       = Move Firefox   to the first  space on the first  display
# - "move_window Slack   2 1"       = Move Slack     to the third  space on the second display
# - "move_window Firefox 1 1 14466" = Move window ID to the second space on the second display
# $1: Application name
# $2: Relative space index
# $3: Relative display index
# $4: Specific window ID(s) to move (optional)
move_window()
{
    APP="$1"
    REL_SPACE_INDEX="$2"
    REL_DISP_INDEX="$3"
    WINDOW_IDS="$4"
    
    # Get windows IDs associated with the application name, and bail if none exist.
    if [[ -z "$WINDOW_IDS" ]]; then
        WINDOW_IDS=$(echo "$WINDOWS" | jq '.[] | select(.app=="'"$APP"'") | .id')
        if [[ -z "$WINDOW_IDS" ]]; then
            echo "[-] Window not found for app $APP"
            return 1
        fi
    fi

    # Cache the JSON blob for the specified display.
    DISPLAY=$(echo "$DISPLAYS" | jq ".[$REL_DISP_INDEX]")

    # Resolve absolute display and space indices.
    ABS_DISP_INDEX=$(get_display_index)
    ABS_SPACE_INDEX=$(get_space_index "$REL_SPACE_INDEX")

    # Create the space if it doesn't already exist.
    if [[ "$ABS_SPACE_INDEX" == 'null' ]]; then
        echo "[*] Creating extra space on display $ABS_DISP_INDEX"
        yabai -m display --focus "$ABS_DISP_INDEX"
        yabai -m space --create

        # Refresh cached JSON blobs to reflect newly created space.
        DISPLAYS=$(get_displays)
        DISPLAY=$(echo "$DISPLAYS" | jq ".[$REL_DISP_INDEX]")
        ABS_SPACE_INDEX=$(get_space_index "$REL_SPACE_INDEX")
    fi

    # Finally, move windows.
    echo "[+] Moving $APP to space $ABS_SPACE_INDEX on display $ABS_DISP_INDEX"
    for ID in $WINDOW_IDS; do
        yabai -m window "$ID" --space "$ABS_SPACE_INDEX"
    done
}

# Cache displays and windows blobs.
DISPLAYS=$(get_displays)
WINDOWS=$(get_windows)

# Get Firefox window IDs grouped by profile.
FIREFOX=$(
    echo "$WINDOWS" |
    jq '.[] | select(.app == "Firefox") | .id, " ", .pid, "\n"' -j |
    while read WID PID; do
        PROFILE=$(ps -p "$PID" | grep 'firefox' | sed -E 's/.*-P ([^ ]+).*/\1/')
        jq -n --arg 'profile' "$PROFILE" --arg 'wid' "$WID" '{"profile": ($profile), "id": $wid}'
    done |
    jq -s 'reduce .[] as $window ({};
           if has($window.profile)
           then .[($window.profile)] += [$window.id]
           else . + {($window.profile): [$window.id]}
           end)'
)

# Move windows.
if [[ $(echo "$DISPLAYS" | jq 'length') == 2 ]]; then
    move_window 'Firefox (Work)' 0 0 "$(echo "$FIREFOX" | jq '.Work | @tsv' -r)"
    move_window 'Google Chrome' 1 0
    move_window 'Burp Suite Professional' 1 0
    move_window 'Firefox (Personal)' 2 0 "$(echo "$FIREFOX" | jq '.Personal | @tsv' -r)"
    move_window 'Microsoft Outlook' 0 1
    move_window 'Microsoft Teams' 1 1
    move_window Slack 2 1
    move_window Discord 3 1
else
    move_window 'Firefox (Work)' 0 0 "$(echo "$FIREFOX" | jq '.Work | @tsv' -r)"
    move_window 'Google Chrome' 1 0
    move_window 'Burp Suite Professional' 1 0
    move_window 'Firefox (Personal)' 2 0 "$(echo "$FIREFOX" | jq '.Personal | @tsv' -r)"
    move_window 'Microsoft Outlook' 3 0
    move_window 'Microsoft Teams' 4 0
    move_window Slack 5 0
    move_window Discord 6 0
fi
