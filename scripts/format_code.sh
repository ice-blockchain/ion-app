#!/bin/bash

FILES=$(find lib test -type f -name '*.dart' -not \( -path 'lib/generated*' -o -path 'lib/l10n*' \) -not \( -name '*.freezed.dart' -o -name '*.g.dart' \))
dart format --set-exit-if-changed $FILES