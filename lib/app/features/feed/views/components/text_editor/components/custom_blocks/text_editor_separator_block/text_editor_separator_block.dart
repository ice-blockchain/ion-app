// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/extensions/extensions.dart';

const textEditorSeparatorKey = 'text-editor-separator';

///
/// Embeds a separator block in the text editor.
///
class TextEditorSeparatorEmbed extends CustomBlockEmbed {
  TextEditorSeparatorEmbed() : super(textEditorSeparatorKey, '');

  static BlockEmbed separatorBlock() => TextEditorSeparatorEmbed();
}

///
/// Embed builder for [TextEditorSeparatorEmbed].
///
class TextEditorSeparatorBuilder extends EmbedBuilder {
  @override
  String get key => textEditorSeparatorKey;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return Container(
      width: 217.0.s,
      height: 24.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.primaryAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58.0.s,
              height: 1.0.s,
              color: context.theme.appColors.onTertararyBackground,
            ),
            SizedBox(width: 10.0.s),
            Container(
              width: 3.0.s,
              height: 3.0.s,
              decoration: BoxDecoration(
                color: context.theme.appColors.onTertararyBackground,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.0.s),
            Container(
              width: 4.0.s,
              height: 4.0.s,
              decoration: BoxDecoration(
                color: context.theme.appColors.onTertararyBackground,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.0.s),
            Container(
              width: 3.0.s,
              height: 3.0.s,
              decoration: BoxDecoration(
                color: context.theme.appColors.onTertararyBackground,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.0.s),
            Container(
              width: 58.0.s,
              height: 1.0.s,
              color: context.theme.appColors.onTertararyBackground,
            ),
          ],
        ),
      ),
    );
  }
}
