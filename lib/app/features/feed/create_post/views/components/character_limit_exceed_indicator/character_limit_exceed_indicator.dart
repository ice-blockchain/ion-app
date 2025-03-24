// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_character_limit_exceed_amount.dart';
import 'package:ion/app/extensions/extensions.dart';

class CharacterLimitExceedIndicator extends HookWidget {
  const CharacterLimitExceedIndicator({
    required this.maxCharacters,
    required this.textEditorController,
    super.key,
  });

  final int maxCharacters;
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    final exceedAmount =
        useTextEditorCharacterLimitExceedAmount(textEditorController, maxCharacters);

    if (exceedAmount <= 0) return const SizedBox.shrink();

    return Text(
      '-$exceedAmount',
      style: context.theme.appTextThemes.caption2.copyWith(
        color: context.theme.appColors.attentionRed,
      ),
    );
  }
}
