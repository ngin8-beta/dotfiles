#!/bin/bash

# Get running container count
running=$(docker ps -q 2>/dev/null | wc -l)

if [ $? -ne 0 ]; then
    echo "N/A"
elif [ "$running" -eq 0 ]; then
    echo "0"
else
    echo "$running"
fi
