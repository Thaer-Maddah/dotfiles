#!/bin/bash
# animated wallpaper with video 

PIDFILE="/var/run/user/$UID/bg.pid"

declare -a PIDs

_screen() {
    xwinwrap -ov -ni -g  1366x768+0+0 -- mpv --fullscreen\
        --no-stop-screensaver \
        --vo=vdpau --hwdec=vdpau \
        --loop-file --no-audio --no-osc --no-osd-bar -wid WID --no-input-default-bindings \
        "$2" &  # file name
    PIDs+=($!)
}

while read p; do
  [[ $(ps -p "$p" -o comm=) == "xwinwrap" ]] && kill -9 "$p";
done < $PIDFILE

sleep 0.5

for i in $( xrandr -q | grep ' connected' | grep -oP '\d+x\d+\+\d+\+\d+')
do
    _screen "$i" "$1"
done

printf "%s\n" "${PIDs[@]}" > $PIDFILE
