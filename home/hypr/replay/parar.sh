#!/bin/bash


notify-send "Grabacion parada"

killall -SIGINT gpu-screen-recorder
