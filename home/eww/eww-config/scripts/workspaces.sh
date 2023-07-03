#!/bin/sh
WORKSPACE_COUNT=6
INACTIVE_CHAR=" "
ACTIVE_CHAR=" "
OPEN_CHAR=" "

active=$(hyprctl activeworkspace -j | jq -r '.name')
open=$(hyprctl workspaces -j | jq -c '[.[] | select(.id > 1) | .name]')

echo -n "["
for ws in `seq 1 $WORKSPACE_COUNT`
do
    if [ "$ws" = "$active" ]; then
        icon=$ACTIVE_CHAR
    else
        if printf '%s' "$open" | grep -qF "$ws"; then
            icon=$OPEN_CHAR
        else
            icon=$INACTIVE_CHAR
        fi
    fi
    if [ "$ws" -gt 1 ]; then
        echo -n ","
    fi
    echo -n "{\"name\":\"$ws\", \"icon\":\"$icon\"}"
done
echo -n "]"
