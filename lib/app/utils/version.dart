// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

/// Compares two version strings and returns:
/// -1 if version1 is smaller than version2
///  0 if version1 is equal to version2
///  1 if version1 is bigger than version2
///
/// Examples:
///   compareVersions('1.0', '1.1')       // returns -1 (1.0 < 1.1)
///   compareVersions('2.5', '2.5.0')     // returns 0 (2.5 == 2.5.0)
///   compareVersions('3.2.1', '3.2')     // returns 1 (3.2.1 > 3.2)
///   compareVersions('1.10', '1.2')      // returns 1 (10 > 2)
int compareVersions(String version1, String version2, {String delimiter = '.'}) {
  final v1Parts = version1.split(delimiter);
  final v2Parts = version2.split(delimiter);

  final maxLength = max(v1Parts.length, v2Parts.length);

  for (var i = 0; i < maxLength; i++) {
    final v1Part = i < v1Parts.length ? int.tryParse(v1Parts[i]) ?? 0 : 0;
    final v2Part = i < v2Parts.length ? int.tryParse(v2Parts[i]) ?? 0 : 0;

    if (v1Part < v2Part) return -1;
    if (v1Part > v2Part) return 1;
  }

  return 0;
}
