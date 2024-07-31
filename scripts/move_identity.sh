#!/bin/bash

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    # Example: ./scripts/move_icons.sh ~/Downloads/icon
    echo "Usage: $0 source_directory"
    exit 1
fi

./scripts/move_image_assets.sh $1 ./assets/images/identity
