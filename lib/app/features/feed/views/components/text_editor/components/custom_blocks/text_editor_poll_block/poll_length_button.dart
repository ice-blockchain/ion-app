// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class PollLengthButton extends StatelessWidget {
  const PollLengthButton({required this.onPollLengthPress, super.key});

  final VoidCallback onPollLengthPress;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Button(
        type: ButtonType.secondary,
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 1)),
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
        onPressed: onPollLengthPress,
      ),
    );
  }
}
