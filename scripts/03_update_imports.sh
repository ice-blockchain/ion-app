#!/usr/bin/env bash

MAPPING_FILE="mapping.txt"
SEARCH_DIRS=("lib" "packages/ion_identity_client/lib")

while read -r old_import new_import; do
    echo "Replacing $old_import with $new_import..."
    
    for SEARCH_DIR in "${SEARCH_DIRS[@]}"; do
        
        find "$SEARCH_DIR" -type f -name "*.dart" ! -name "*.g.dart" ! -name "*.c.dart" -exec sed -i '' "s|$old_import|$new_import|g" {} +
    done
    echo "Done replacing $old_import."
done < "$MAPPING_FILE"

echo "All imports updated according to $MAPPING_FILE."
