// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

void removeBlock(
  QuillController controller,
  Embed node,
) {
  final delta = controller.document.toDelta();
  var blockIndex = -1;
  var blockLength = 0;
  var currentIndex = 0;

  for (final operation in delta.operations) {
    final length = operation.length ?? 1;

    if (operation.isInsert && operation.data is Map<String, dynamic>) {
      final data = operation.data! as Map<String, dynamic>;
      if (data.containsKey('custom')) {
        blockIndex = currentIndex;
        blockLength = length;
        break;
      }
    }
    currentIndex += length;
  }

  if (blockIndex != -1) {
    final deleteDelta = Delta()
      ..retain(blockIndex)
      ..delete(blockLength);

    controller.compose(
      deleteDelta,
      TextSelection.collapsed(offset: blockIndex),
      ChangeSource.local,
    );
  }
}
