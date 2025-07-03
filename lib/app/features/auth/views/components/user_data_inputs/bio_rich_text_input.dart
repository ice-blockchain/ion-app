// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/text_editor/components/rich_text_input.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/utils/validators.dart';
import 'package:ion/generated/assets.gen.dart';

const int _bioMaxLength = 140;

class BioRichTextInput extends StatelessWidget {
  const BioRichTextInput({
    required this.textEditorKey,
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  final GlobalKey<TextEditorState> textEditorKey;
  final ValueChanged<String> onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return RichTextInput(
      textEditorKey: textEditorKey,
      initialValue: initialValue,
      labelText: context.i18n.profile_bio,
      prefixIconAssetName: Assets.svg.iconProfileBio,
      onChanged: onChanged,
      validator: (value) {
        if (Validators.isInvalidLength(value, maxLength: _bioMaxLength)) {
          return context.i18n.error_input_length_max(_bioMaxLength);
        }
        return null;
      },
    );
  }
}
