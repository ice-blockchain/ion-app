// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/services/logger/logger.dart';

// This hook will check for poll existence in the editor's content
bool useHasPoll(QuillController textEditorController) {
  final hasPoll = useState(false);

  useEffect(
    () {
      void checkPoll() {
        final delta = textEditorController.document.toDelta();
        var pollExists = false;

        for (final operation in delta.operations) {
          if (operation.isInsert && operation.data is Map<String, dynamic>) {
            final data = operation.data! as Map<String, dynamic>;
            if (data.containsKey('custom')) {
              final customData = data['custom'];

              if (_containsPollKey(customData)) {
                pollExists = true;
                break;
              }
            }
          }
        }

        hasPoll.value = pollExists;
      }

      textEditorController.addListener(checkPoll);

      checkPoll();

      return () {
        textEditorController.removeListener(checkPoll);
      };
    },
    [textEditorController],
  );

  return hasPoll.value;
}

bool _containsPollKey(dynamic customData) {
  Map<String, dynamic>? parsedData;

  if (customData is Map<String, dynamic>) {
    parsedData = customData;
  } else if (customData is String) {
    try {
      parsedData = jsonDecode(customData) as Map<String, dynamic>?;
    } catch (e) {
      Logger.log('Failed to parse custom data as JSON: $e');
    }
  }

  return parsedData != null && parsedData.containsKey('poll');
}
