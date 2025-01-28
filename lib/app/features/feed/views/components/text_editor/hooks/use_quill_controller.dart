// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

QuillController useQuillController({String? defaultText}) {
  final document = defaultText != null
      ? Document.fromDelta(Delta.fromJson(jsonDecode(defaultText) as List<dynamic>))
      : null;
  final textEditorController = useRef(
    document != null
        ? QuillController(
            document: document,
            selection: TextSelection.collapsed(offset: document.length - 1),
          )
        : QuillController.basic(),
  );

  useEffect(
    () {
      return textEditorController.value.dispose;
    },
    [],
  );

  return textEditorController.value;
}
