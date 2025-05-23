// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/quill_delta.dart';

List<String> extractTags(Delta content) {
  return content.operations
      .where(
    (operation) =>
        operation.isInsert &&
        (operation.value is String) &&
        ((operation.value as String).startsWith('#') ||
            (operation.value as String).startsWith(r'$')),
  )
      .map((operation) {
    return (operation.value as String).trim();
  }).toList();
}
