#!/usr/bin/env bash

SEARCH_DIRS=("lib" "packages/ion_identity_client/lib")

for SEARCH_DIR in "${SEARCH_DIRS[@]}"; do
    find "$SEARCH_DIR" -type f -name "*.c.dart" | while read -r file; do
        sed -i '' "s/part '\([^']*\)\.freezed\.dart';/part '\1.c.freezed.dart';/g" "$file"
        sed -i '' "s/part '\([^']*\)\.g\.dart';/part '\1.c.g.dart';/g" "$file"
        echo "Fixed part directives in $file"
    done
done
