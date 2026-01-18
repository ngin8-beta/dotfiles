#!/bin/bash

# Launch ghostty and make it float
ghostty -e bash -c "$1" &
sleep 0.3
i3-msg '[con_id="__focused__"] floating enable, resize set 800 400, move position center'
