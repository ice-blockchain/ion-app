// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';

class CodeBlockContent extends HookConsumerWidget {
  const CodeBlockContent({
    required this.onRemoveBlock,
    super.key,
  });

  final VoidCallback onRemoveBlock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeText = useState('');
    final textController = useTextEditingController(text: codeText.value);
    final focusNode = useFocusNode();

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0.s, top: 8.0.s, left: 12.0.s, right: 12.0.s),
      child: KeyboardListener(
        focusNode: focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              codeText.value.trim().isEmpty) {
            onRemoveBlock();
          }
        },
        child: TextField(
          controller: textController,
          onChanged: (value) {
            codeText.value = value;
          },
          maxLines: null,
          cursorColor: context.theme.appColors.primaryAccent,
          cursorHeight: 22.0.s,
          style: TextStyle(
            fontFamily: 'Monaco',
            fontSize: 12.0.s,
            color: context.theme.appColors.primaryText,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
