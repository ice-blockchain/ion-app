#!/usr/bin/env bash

# This script:
# 1. Uses the `sed_script.sed` file created by the previous script.
# 2. Applies all of the replacements to every .dart file (except *.g.dart) in the project in one pass.
#    This ensures that all imports and exports referencing old paths are updated to the new .c.dart paths,
#    including those in barrel files and files with relative imports.
SEARCH_DIRS=("lib" "packages/ion_identity_client/lib" "test")
SED_SCRIPT="sed_script.sed"

for SEARCH_DIR in "${SEARCH_DIRS[@]}"; do
    find "$SEARCH_DIR" -type f -name "*.dart" ! -name "*.g.dart" -print0 \
    | xargs -0 sed -i '' -f "$SED_SCRIPT"
done

echo "All imports updated according to $SED_SCRIPT."
