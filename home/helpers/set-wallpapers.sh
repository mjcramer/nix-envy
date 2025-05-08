#!/bin/bash

# Define wallpapers (Put as many as you have desktops. If fewer, it will repeat.)
WALLPAPERS=(
    "$HOME/.wallpaper/black-hole-quasar.jpg"
    "$HOME/.wallpaper/neutron-star.jpg"
    "$HOME/.wallpaper/crab-nebula.jpg"
)

NUM_DESKTOPS=$(/usr/bin/osascript -e 'tell application "System Events" to count of desktops')

for (( i=1; i<=NUM_DESKTOPS; i++ ))
do
  WALLPAPER_INDEX=$(( (i-1) % ${#WALLPAPERS[@]} ))
  WALLPAPER_PATH="${WALLPAPERS[$WALLPAPER_INDEX]}"

  echo "Setting wallpaper for desktop $i to $WALLPAPER_PATH"

  /usr/bin/osascript -e "
    tell application \"System Events\"
      set picture of desktop $i to \"$WALLPAPER_PATH\"
    end tell
  "
done
