#!/bin/sh

picom --backend glx --fade-exclude 'class_g = "xsecurelock"'  -b -i 1.0 

feh --bg-fill --randomize ~/Pictures/wallpapers/*
nm-applet &

 


