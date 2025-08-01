#!/bin/bash
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

WAYVNCCTL=${WAYVNCCTL:-wayvncctl}

connection_count_now() {
    echo "Total clients: $1"
}

while IFS= read -r EVT; do
    case "$(jq -r '.method' <<<"$EVT")" in
        client-connected)
            count=$(jq -r '.params.connection_count' <<<"$EVT")
            connection_count_now "$count"
            hyprctl keyword monitor HDMI-A-4,disabled
            hyprctl keyword monitor HDMI-A-3,disabled
            hyprctl keyword monitor DP-1,disabled
            ;;
        client-disconnected)
            hyprctl reload
            hyprctl dispatch movecursor 1920 1080
            hyprctl dispatch exec hyprlock
            hyprctl dispatch exec systemctl hybrid-sleep
            ;;
        wayvnc-shutdown)
            echo "wayvncctl is no longer running"
            connection_count_now 0
            ;;
        wayvnc-startup)
            echo "Ready to receive wayvnc events"
            ;;
    esac
    echo $EVT
done < <("$WAYVNCCTL" --wait --reconnect --json event-receive)