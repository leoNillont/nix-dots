#!/bin/bash

killall -SIGUSR1 gpu-screen-recorder

if [ $? -ne 0 ]; then
    notify-send "No esta grabando"
    exit 1
fi
notify-send "Grabación guardada"
