#!/bin/bash

source "$(dirname "$0")/utils.sh"

FILES=$(find lib test -type f -name '*.dart' -not \( -path 'lib/generated*' -o -path 'lib/l10n*' \) -not \( -name '*.freezed.dart' -o -name '*.g.dart' \))
use_asdf dart format --line-length=100 --set-exit-if-changed $FILES