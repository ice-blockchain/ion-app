// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryShareButton extends StatelessWidget {
  const StoryShareButton({
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.large(
      child: Button(
        mainAxisSize: MainAxisSize.max,
        label: Text(context.i18n.button_share_story),
        trailingIcon: Assets.svgIconFeedSendbutton.icon(),
        onPressed: onPressed ?? () {},
        disabled: isLoading || onPressed == null,
        type: onPressed == null ? ButtonType.disabled : ButtonType.primary,
      ),
    );
  }
}
