#!/bin/bash

# This script processes ARB files by checking if the keys from app_en.arb (or specified keys)
# are used in a given library folder. If a key is not found, the script outputs the key. If the --dryRun flag is not provided,
# the script will also remove the key from all ARB files in the specified ARB folder.

# Usage:
# ./process_arb.sh <path_to_arb_folder> <path_to_lib_folder> [--dryRun] [--translations keys]
#
# Parameters:
# <path_to_arb_folder>   - Path to the folder containing ARB files.
# <path_to_lib_folder>   - Path to the library folder to search for keys.
# --dryRun               - (Optional) Perform a dry run without modifying the ARB files.
# --translations keys    - (Optional) Comma-separated list of translation keys to check. If not provided, keys from app_en.arb will be used.
#
# Examples:
# ./process_arb.sh /path/to/arb/folder /path/to/lib/folder
# ./process_arb.sh /path/to/arb/folder /path/to/lib/folder --dryRun
# ./process_arb.sh /path/to/arb/folder /path/to/lib/folder --translations key1,key2,key3
# ./process_arb.sh /path/to/arb/folder /path/to/lib/folder --dryRun --translations key1,key2,key3

# Function to show usage
usage() {
  echo "Usage: $0 <path_to_arb_folder> <path_to_lib_folder> [--dryRun] [--translations keys]"
  echo "  --dryRun              Perform a dry run without modifying the ARB files"
  echo "  --translations keys   Comma-separated list of translation keys to check"
  exit 1
}

# Check if at least two arguments are passed (path to ARB files and lib folder)
if [ "$#" -lt 2 ]; then
  usage
fi

# Extract the arguments
ARB_FOLDER=$1
LIB_FOLDER=$2
DRY_RUN=false
TRANSLATION_KEYS=()

# Parse optional arguments
shift 2
while (( "$#" )); do
  case "$1" in
    --dryRun)
      DRY_RUN=true
      shift
      ;;
    --translations)
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        IFS=',' read -r -a TRANSLATION_KEYS <<< "$2"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
        exit 1
      fi
      ;;
    *)
      echo "Error: Unsupported flag $1" >&2
      usage
      ;;
  esac
done

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "jq is required but it's not installed. Please install jq and try again."
  exit 1
fi

# Path to the app_en.arb file
APP_EN_ARB="${ARB_FOLDER}/app_en.arb"

# Read the keys from app_en.arb if no translation keys are provided
if [ ${#TRANSLATION_KEYS[@]} -eq 0 ]; then
  TRANSLATION_KEYS=$(jq -r 'keys[]' "$APP_EN_ARB")
else
  TRANSLATION_KEYS=$(printf "%s\n" "${TRANSLATION_KEYS[@]}")
fi

# Loop through each key
for KEY in $TRANSLATION_KEYS; do
  # Search for the key in the lib folder recursively
  FOUND=$(grep -r "\"$KEY\"" "$LIB_FOLDER" 2>/dev/null)
  
  # If the key is not found
  if [ -z "$FOUND" ]; then
    echo "Key not found: $KEY"
    if [ "$DRY_RUN" = false ]; then
      # Loop through each ARB file in the ARB folder and remove the key
      for ARB_FILE in "$ARB_FOLDER"/*.arb; do
        jq "del(.$KEY)" "$ARB_FILE" > "${ARB_FILE}.tmp" && mv "${ARB_FILE}.tmp" "$ARB_FILE"
      done
    fi
  fi
done

echo "Processing completed."
