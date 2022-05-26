#!/bin/bash
if [[ -z $1 ]]; then
    # Playing video
    du -a | cut -f2- | grep -iE "mp4$|mp3$|webm$|m4a$|wav$|ogg$|mkv$" | dmenu -i -l 30 -sb "#C95A49" | xargs -I "{}" mpv "{}" # || clear && dialog --msgbox "MPV does not support selected file format" 5 45'
else 
    # Playing audio 
    du -a | cut -f2- | grep -iE "mp4$|mp3$|webm$|m4a$|wav$|ogg$|mkv$" | dmenu -i -l 30 -sb "#C95000" | xargs -I "{}" mpv --no-video "{}" 
fi 

