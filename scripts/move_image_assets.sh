#!/bin/bash

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 source_directory target_directory"
    exit 1
fi

# Assign input arguments to variables
SOURCE_DIR=$1
TARGET_DIR=$2

# Create an array of scale directories
declare -a scales=("1.5x" "2.0x" "3.0x" "4.0x")

# Move the main PNG files from the source to the target directory
for file in "$SOURCE_DIR"/*.png; do
    # Ensure the target directory exists
    mkdir -p "$TARGET_DIR"
    mv "$file" "$TARGET_DIR/"
done

# Loop through each scale and move the files from source subdirectories to target subdirectories
for scale in "${scales[@]}"; do
    scaled_dir="$SOURCE_DIR/$scale"
    target_scaled_dir="$TARGET_DIR/$scale"

    # Check if the source scaled directory exists
    if [ -d "$scaled_dir" ]; then
        # Ensure the target scaled directory exists
        mkdir -p "$target_scaled_dir"

        # Move all PNG files from the source scaled directory to the target scaled directory
        for scaled_file in "$scaled_dir"/*.png; do
            mv "$scaled_file" "$target_scaled_dir/"
        done
    fi
done
