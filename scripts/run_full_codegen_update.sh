#!/usr/bin/env bash

# This script orchestrates the entire process by running:
# 1. prepare_codegen_files.sh
# 2. adjust_part_directives.sh
# 3. create_sed_script.sh
# 4. apply_import_replacements.sh
#
# Running this script will trigger each step in sequence, so we only need to run this one script.

set -e

./scripts/prepare_codegen_files.sh
./scripts/adjust_part_directives.sh
./scripts/create_sed_script.sh
./scripts/apply_import_replacements.sh

echo "All steps completed successfully."
