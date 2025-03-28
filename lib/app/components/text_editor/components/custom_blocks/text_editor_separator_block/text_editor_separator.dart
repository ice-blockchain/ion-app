// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_close.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_dot.dart';
import 'package:ion/app/extensions/extensions.dart';

class TextEditorSeparator extends HookWidget {
  const TextEditorSeparator({
    required this.onRemove,
    this.readOnly = false,
    super.key,
  });

  final VoidCallback onRemove;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final isSelected = useState(false);

    final separatorWidth = 58.0.s;
    final separatorHeight = 1.0.s;
    final smallDotSize = 3.0.s;
    final bigDotSize = 4.0.s;
    final dotsPadding = 6.0.s;
    final separatorsPadding = 10.0.s;

    return GestureDetector(
      onTap: () {
        isSelected.value = !isSelected.value;
      },
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0.s),
          child: Container(
            width: 217.0.s,
            height: 24.0.s,
            decoration: BoxDecoration(
              color: isSelected.value
                  ? context.theme.appColors.primaryAccent.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16.0.s),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: separatorWidth,
                      height: separatorHeight,
                      color: context.theme.appColors.onTertararyBackground,
                    ),
                    SizedBox(width: separatorsPadding),
                    TextEditorSeparatorDot(size: smallDotSize),
                    SizedBox(width: dotsPadding),
                    TextEditorSeparatorDot(size: bigDotSize),
                    SizedBox(width: dotsPadding),
                    TextEditorSeparatorDot(size: smallDotSize),
                    SizedBox(width: separatorsPadding),
                    Container(
                      width: separatorWidth,
                      height: separatorHeight,
                      color: context.theme.appColors.onTertararyBackground,
                    ),
                  ],
                ),
                if (isSelected.value && !readOnly)
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: TextEditorSeparatorClose(
                      onPressed: onRemove,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
