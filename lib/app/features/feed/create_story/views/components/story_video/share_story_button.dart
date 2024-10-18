// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareStoryButton extends StatelessWidget {
  const ShareStoryButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.large(
      child: Button(
        mainAxisSize: MainAxisSize.max,
        label: Text(context.i18n.button_share_story),
        trailingIcon: Assets.svg.iconFeedSendbutton.icon(),
        onPressed: onPressed,
      ),
    );
  }
}
