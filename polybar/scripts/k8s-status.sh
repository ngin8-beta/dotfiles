#!/bin/bash

# Get running pods count
pods=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running 2>/dev/null | tail -n +2 | wc -l)

if [ $? -ne 0 ]; then
    echo "N/A"
else
    echo "$pods"
fi
