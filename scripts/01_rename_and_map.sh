#!/usr/bin/env bash

SEARCH_DIRS=("lib/app" "packages/ion_identity_client/lib")
MAPPING_FILE="mapping.txt"

> "$MAPPING_FILE"

for SEARCH_DIR in "${SEARCH_DIRS[@]}"; do
    
    find "$SEARCH_DIR" -type f -name "*.dart" ! -name "*.g.dart" | while read -r file; do
        
        if grep -Eq "part '.*\.freezed\.dart';" "$file" || grep -Eq "part '.*\.g\.dart';" "$file"; then
            old_file="$file"
            new_file="${file%.dart}.c.dart"

            if [[ "$old_file" == lib/* ]]; then
              pkg_prefix="package:ion/"
              relative_path="${old_file
              relative_new_path="${new_file
            elif [[ "$old_file" == packages/ion_identity_client/lib/* ]]; then
              pkg_prefix="package:ion_identity_client/"
              relative_path="${old_file
              relative_new_path="${new_file
            else
              
              continue
            fi

            old_import_full="${pkg_prefix}${relative_path}"
            new_import_full="${pkg_prefix}${relative_new_path}"

            echo "$old_import_full $new_import_full" >> "$MAPPING_FILE"

            mv "$old_file" "$new_file"
            echo "Renamed $old_file to $new_file"
        fi
    done
done

echo "Mapping created in $MAPPING_FILE"
