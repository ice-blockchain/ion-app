#!/bin/bash

# Check if exactly three arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 source_directory"
    exit 1
fi

./scripts/move_image_assets.sh $1 ./assets/images/icons