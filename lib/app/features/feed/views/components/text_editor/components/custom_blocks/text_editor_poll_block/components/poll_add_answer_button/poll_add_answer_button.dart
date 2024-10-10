// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class PollAddAnswerButton extends StatelessWidget {
  const PollAddAnswerButton({required this.onAddAnswerPress, super.key});

  final VoidCallback onAddAnswerPress;

  @override
  Widget build(BuildContext context) {
    return Align(
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
        leadingIcon:
            Assets.svg.iconPostAddanswer.icon(color: context.theme.appColors.primaryAccent),
        leadingIconOffset: 0,
        onPressed: onAddAnswerPress,
      ),
    );
  }
}
