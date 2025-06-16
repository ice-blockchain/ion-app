// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    required this.onPressed,
    required this.following,
    this.followLabel,
    super.key,
  });

  final VoidCallback onPressed;

  final bool following;

  final String? followLabel;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      leadingIcon: IconAssetColored(following ? Assets.svgIconSearchFollowers : Assets.svgIconSearchFollow,
        color: following
            ? context.theme.appColors.primaryAccent
            : context.theme.appColors.onPrimaryAccent,
        size: 16,
      ),
      type: following ? ButtonType.outlined : ButtonType.primary,
      tintColor: following ? context.theme.appColors.primaryAccent : null,
      label: Text(
        following ? context.i18n.button_following : followLabel ?? context.i18n.button_follow,
        style: context.theme.appTextThemes.caption.copyWith(
          color: following
              ? context.theme.appColors.primaryAccent
              : context.theme.appColors.secondaryBackground,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(87.0.s, 28.0.s),
        padding: EdgeInsets.symmetric(horizontal: 15.0.s),
      ),
    );
  }
}
