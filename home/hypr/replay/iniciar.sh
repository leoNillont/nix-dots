#!/usr/bin/env bash

killall -SIGINT gpu-screen-recorder

notify-send "Grabacion (re)iniciada"

gpu-screen-recorder -w screen -f 120 -a "$(pactl get-default-sink).monitor" -a "$(pactl get-default-source)" -o ~/Videos/replay/ -r 60 -c mp4
