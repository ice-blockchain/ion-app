#!/usr/bin/env bash

# This script:
# 1. Reads the `mapping.txt` file which contains old and new paths for imports and exports.
# 2. Generates `sed_script.sed`, a sed commands file that includes a `s|old|new|g` line for each mapping.
#    This `sed_script.sed` will be used to batch-update all imports/exports in the project.
#
# After running this script, it will create a single `sed_script.sed` file with all necessary replacements.

MAPPING_FILE="mapping.txt"
SED_SCRIPT="sed_script.sed"

> "$SED_SCRIPT"

while read -r old_import new_import; do
    echo "s|$old_import|$new_import|g" >> "$SED_SCRIPT"
done < "$MAPPING_FILE"

echo "sed script generated in $SED_SCRIPT"
