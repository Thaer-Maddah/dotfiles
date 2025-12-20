#!/bin/bash

# File extension
ext="mp4$|mp3$|webm$|m4a$|wav$|ogg$|mkv$"
#file=$PWD

# We must put else {condition} in curly braces to avoid subshell procces
# first argument option for video or audio, n for audio anything else for video
# second argument fot directory, leave it empty for current directory
[[ $1 == "n" || $1 == "no" ]] && { option="--no-video"; menu_color="#C95000"; } || { option="--video-osd=no"; menu_color="#C95A49"; }
[[ -n $2 ]] && file=$2 || { file="."; }
# Playing video
du -a "$file" | cut -f2- | grep -iE "$ext" | dmenu -i -l 30 -sb "$menu_color"  | xargs -I {} mpv {} "$option" #1>/dev/null 2>/dev/null & # Run video and diswoen mpv # || clear && dialog --msgbox "MPV does not support selected file format" 5 45'

