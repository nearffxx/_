#!/usr/bin/env sh

# Terminate already running instances
killall -q waybar

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Launch main
waybar &


# Terminate already running instances
killall -q swayidle

# Wait until the processes have been shut down
while pgrep -x swayidle >/dev/null; do sleep 1; done

# Launch main
swayidle -w \
         timeout 300 'swaylock -f' \
         before-sleep 'swaylock -f' &
