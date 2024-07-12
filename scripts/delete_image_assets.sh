#!/bin/bash

# TODO::improve
# Deletes assets
#
# Usage Example:
# ./scripts/delete_image_assets.sh ./assets/images/icons file1.png file2.png file3.png

# Check if at least two arguments are passed (directory and at least one file name)
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <directory> <file1> [file2 ... fileN]"
  exit 1
fi

# Extract the directory path from the first argument
DIRECTORY=$1
shift  # Shift the arguments to remove the first one (directory)

# Create an array of file names from the remaining arguments
FILE_NAMES=("$@")

# Define the subdirectories to search in
SUBDIRS=("1.5x" "2.0x" "3.0x" "4.0x")

# Loop through each file name
for FILE_NAME in "${FILE_NAMES[@]}"; do
  # Remove the file in the main directory if it exists
  if [ -e "${DIRECTORY}/${FILE_NAME}" ]; then
    rm "${DIRECTORY}/${FILE_NAME}"
    echo "Removed ${DIRECTORY}/${FILE_NAME}"
  fi

  # Loop through each subdirectory and remove the file if it exists
  for SUBDIR in "${SUBDIRS[@]}"; do
    FILE_PATH="${DIRECTORY}/${SUBDIR}/${FILE_NAME}"
    if [ -e "$FILE_PATH" ]; then
      rm "$FILE_PATH"
      echo "Removed $FILE_PATH"
    fi
  done
done