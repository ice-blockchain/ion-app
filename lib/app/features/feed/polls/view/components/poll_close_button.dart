// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class PollCloseButton extends StatelessWidget {
  const PollCloseButton({required this.onClosePress, super.key});

  final VoidCallback onClosePress;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: -10.0.s,
      end: -10.0.s,
      child: Button.icon(
        size: 24.0.s,
        type: ButtonType.outlined,
        icon: Assets.svgIconSheetClose.icon(
          size: 14.4.s,
          color: context.theme.appColors.primaryText,
        ),
        borderColor: context.theme.appColors.onTerararyFill,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9.6.s)),
          ),
          backgroundColor: context.theme.appColors.tertararyBackground,
        ),
        onPressed: onClosePress,
      ),
    );
  }
}
