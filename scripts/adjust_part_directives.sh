#!/usr/bin/env bash

# This script:
# 1. Looks for all files that were renamed to *.c.dart in the specified directories.
# 2. Updates their `part` directives to point to the .c.freezed.dart and .c.g.dart files
#    instead of the original *.freezed.dart or *.g.dart.
#
# After this script, the part directives in the renamed files match the new naming convention.

SEARCH_DIRS=("lib" "packages/ion_identity_client/lib")

for SEARCH_DIR in "${SEARCH_DIRS[@]}"; do
    find "$SEARCH_DIR" -type f -name "*.c.dart" | while read -r file; do
        sed -i '' "s/part '\([^']*\)\.freezed\.dart';/part '\1.c.freezed.dart';/g" "$file"
        sed -i '' "s/part '\([^']*\)\.g\.dart';/part '\1.c.g.dart';/g" "$file"
        echo "Fixed part directives in $file"
    done
done
