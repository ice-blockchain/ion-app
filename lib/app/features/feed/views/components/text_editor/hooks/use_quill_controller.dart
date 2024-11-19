// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

QuillController useQuillController({String? defaultText}) {
  final textEditorController = useRef(
    defaultText != null
        ? QuillController(
            document: Document()..insert(0, defaultText),
            selection: TextSelection.collapsed(offset: defaultText.length),
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
