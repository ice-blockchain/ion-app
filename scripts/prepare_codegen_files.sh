#!/usr/bin/env bash

# This script:
# 1. Finds all Dart files (except *.g.dart) in specified directories.
# 2. Identifies files that contain part directives referencing *.freezed.dart or *.g.dart,
#    which need to be renamed to introduce ".c.dart" suffixes.
# 3. Renames those files accordingly (from *.dart to *.c.dart).
# 4. Records both their original (package-based) import paths and the new import paths in `mapping.txt`.
# 5. Additionally, for files that need renaming, it also adds relative filename mapping
#    (basename only) to handle relative imports/exports in barrel files.
#
# The output is `mapping.txt` which will be used later by other scripts to update imports.

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
              relative_path="${old_file#lib/}"
              relative_new_path="${new_file#lib/}"
            elif [[ "$old_file" == packages/ion_identity_client/lib/* ]]; then
              pkg_prefix="package:ion_identity_client/"
              relative_path="${old_file#packages/ion_identity_client/lib/}"
              relative_new_path="${new_file#packages/ion_identity_client/lib/}"
            else
              continue
            fi

            old_import_full="${pkg_prefix}${relative_path}"
            new_import_full="${pkg_prefix}${relative_new_path}"

            echo "$old_import_full $new_import_full" >> "$MAPPING_FILE"

            filename_old=$(basename "$old_file")
            filename_new=$(basename "$new_file")
            echo "$filename_old $filename_new" >> "$MAPPING_FILE"

            mv "$old_file" "$new_file"
            echo "Renamed $old_file to $new_file"
        fi
    done
done

echo "Mapping created in $MAPPING_FILE"
