// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

extension QuillControllerExt on QuillController {
  void clearContent({bool ignoreFocus = true}) {
    /// calling `.replaceText` instead of `.clear` due to missing `ignoreFocus` parameter.
    replaceText(
      0,
      plainTextEditingValue.text.length - 1,
      '',
      const TextSelection.collapsed(offset: 0),
      ignoreFocus: ignoreFocus,
    );
  }
}
