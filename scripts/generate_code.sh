#!/bin/bash

# https://pub.dev/packages/flutter_gen
# https://pub.dev/packages/freezed
# https://pub.dev/packages/json_serializable
# https://pub.dev/packages/widgetbook
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
