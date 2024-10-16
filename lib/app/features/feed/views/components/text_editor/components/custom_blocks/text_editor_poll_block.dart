// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

const textEditorPollKey = 'text-editor-poll';

///
/// Embeds a poll in the text editor.
///

class TextEditorPollEmbed extends CustomBlockEmbed {
  TextEditorPollEmbed() : super(textEditorPollKey, '');
}

///
/// Embed builder for [TextEditorPollBuilder].
///
class TextEditorPollBuilder extends EmbedBuilder {
  TextEditorPollBuilder({this.onPollLengthPress});
  final VoidCallback? onPollLengthPress;

  @override
  String get key => textEditorPollKey;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.appColors.onPrimaryAccent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.theme.appColors.onTerararyFill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.s),
            child: Column(
              children: [
                SizedBox(height: 10.0.s),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10.0.s),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 36.0.s,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.theme.appColors.onSecondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Button(
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
                    ),
                    type: ButtonType.secondary,
                    label: Text(
                      context.i18n.poll_add_answer_button_title,
                      style: context.theme.appTextThemes.caption.copyWith(
                        color: context.theme.appColors.primaryAccent,
                      ),
                    ),
                    backgroundColor: context.theme.appColors.secondaryBackground,
                    borderColor: context.theme.appColors.secondaryBackground,
                    leadingIcon: Assets.svg.iconPlusCreatechannel
                        .icon(color: context.theme.appColors.primaryAccent),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Button(
            type: ButtonType.secondary,
            style: const ButtonStyle(
              padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
            ),
            label: Text(
              context.i18n.poll_length_button_title,
              style: context.theme.appTextThemes.caption.copyWith(
                color: context.theme.appColors.primaryAccent,
              ),
            ),
            backgroundColor: context.theme.appColors.secondaryBackground,
            borderColor: context.theme.appColors.secondaryBackground,
            leadingIcon: Assets.svg.iconBlockTime.icon(size: 16.0.s),
            onPressed: () {
              onPollLengthPress?.call();
            },
          ),
        ),
      ],
    );
  }
}
