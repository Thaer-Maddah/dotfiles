#!/usr/bin/bash

dir="$HOME/Pictures/Screenshots"
choice=$(echo -e 'Screen\nWindow\nRegion\nClipboard' | dmenu -i -sb "#f76d23" )
# focused=`swaymsg -t get_tree | jq '.. | (.nodes? // empty)[] | select(.focused and .pid) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'`
xy=$(hyprctl activewindow | grep at: | awk ' {print $2}')
size=$(hyprctl activewindow | grep size | awk '{print $2}')

case $choice in
    Screen) slurp -o  | xargs -I "{}" grim -g "{}" $dir/screenshot_$(date +'%s.png');;
    # Window) grim -g "$(eval echo $focused)" $dir/screenshot_$(date +'%s.png');;
    Window) echo grim -g $xy $size $dir/screenshot_$(date +'%s.png');;
    Region) grim -g "$(slurp -o)" $dir/screenshot_$(date +'%s.png');;
    Clipboard) grim -g "$(slurp)" - | swappy -f -
esac

