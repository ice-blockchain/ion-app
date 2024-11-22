// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateChannelButton extends StatelessWidget {
  const CreateChannelButton({
    required this.onPressed,
    this.disabled = false,
    super.key,
  });

  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0.s,
          horizontal: 44.0.s,
        ),
        child: Button(
          type: disabled ? ButtonType.disabled : ButtonType.primary,
          mainAxisSize: MainAxisSize.max,
          minimumSize: Size(56.0.s, 56.0.s),
          leadingIcon: Assets.svg.iconPlusCreatechannel.icon(
            color: context.theme.appColors.onPrimaryAccent,
          ),
          label: Text(
            context.i18n.channel_create_action,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
