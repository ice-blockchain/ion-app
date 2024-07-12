#!/bin/bash

# Description:
# This script processes assets by checking if they exist in a given app folder. It collects all file paths from the assets folder
# recursively, ignores specific subfolders, and searches for these files in the app folder. If the --dryRun flag is true, it outputs
# files that are not found. If the flag is false or not passed, it removes the corresponding files from the assets folder recursively.

# Usage:
# ./clean_assets.sh <path_to_assets_folder> <path_to_app_folder> [--dryRun]
#
# Parameters:
# <path_to_assets_folder> - Path to the folder containing assets.
# <path_to_app_folder>    - Path to the app folder to search for assets.
# --dryRun                - (Optional) Perform a dry run without removing the assets.
#
# Examples:
# ./scripts/clean_assets.sh ./assets/images ./lib/app
# ./scripts/clean_assets.sh ./assets/images ./lib/app --dryRun

# Function to show usage
usage() {
  echo "Usage: $0 <path_to_assets_folder> <path_to_app_folder> [--dryRun]"
  echo "  --dryRun             Perform a dry run without removing the assets"
  exit 1
}

# Check if at least two arguments are passed (path to assets folder and app folder)
if [ "$#" -lt 2 ]; then
  usage
fi

# Extract the arguments
ASSETS_FOLDER=$1
APP_FOLDER=$2
DRY_RUN=false

# Parse optional arguments
shift 2
while (( "$#" )); do
  case "$1" in
    --dryRun)
      DRY_RUN=true
      shift
      ;;
    *)
      echo "Error: Unsupported flag $1" >&2
      usage
      ;;
  esac
done

# Function to collect asset files, ignoring certain folders
collect_asset_files() {
  find "$1" -type f \( ! -path "*/1.5x/*" ! -path "*/2.0x/*" ! -path "*/3.0x/*" ! -path "*/4.0x/*" \)
}

to_generated_asset_name() {
  local input_string="$1"

  # Remove file extension (if any)
  local base_name="${input_string%.*}"

  # Replace underscores with camel case
  local camel_case=$(echo "$base_name" | awk -F'[-_]' '{
    for (i = 1; i <= NF; i++) {
      if (i == 1) {
        $i = tolower($i)
      } else {
        $i = toupper(substr($i, 1, 1)) tolower(substr($i, 2))
      }
    }
    print
  }' OFS='')

  # Replace slashes with dots and add a dot at the beginning
  local transformed_string=".$(echo "$camel_case" | tr '/' '.')"

  echo "$transformed_string"
}

remove_asset() {
  local file_path="$1"
  local base_filename=$(basename "$file_path")
  local dir_path=$(dirname "$file_path")
  
  # Remove the file itself
  if [ -f "$file_path" ]; then
    rm -f "$file_path"
    echo "Removed file: $file_path"
  else
    echo "File not found: $file_path"
    return 1
  fi

  # Remove files with the same name in subfolders 1.5x, 2.0x, 3.0x, 4.0x
  for folder_name in 1.5x 2.0x 3.0x 4.0x; do
    local versioned_folder="$dir_path/$folder_name"
    local file_to_remove="$versioned_folder/$base_filename"
    
    if [ -f "$file_to_remove" ]; then
      rm -f "$file_to_remove"
      echo "Removed file: $file_to_remove"
    fi
  done
}

# Collect all asset files
ASSET_FILES=$(collect_asset_files "$ASSETS_FOLDER")

# Loop through each asset file
for FILE in $ASSET_FILES; do
  # Get relative path from assets folder
  RELATIVE_PATH="${FILE#$ASSETS_FOLDER/}"

  # Get generated Assets name
  GENERATED_ASSET_NAME=$(to_generated_asset_name "$(basename $(dirname "$FILE"))/$(basename $FILE)")

  # Search for both snake case and camel case in the app folder content recursively
  FOUND=$(grep -r -l -e "$RELATIVE_PATH" -e "$GENERATED_ASSET_NAME" "$APP_FOLDER" 2>/dev/null)

  # Check if the file exists in the app folder
  if [ -z "$FOUND" ]; then
    echo "File not found in app folder: $RELATIVE_PATH"
    if [ "$DRY_RUN" = false ]; then
      # Remove the file from assets folder
      remove_asset "$ASSETS_FOLDER/$RELATIVE_PATH"
    fi
  fi
done

echo "Processing completed."
