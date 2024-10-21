// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    required this.onPressed,
    required this.following,
    super.key,
  });

  final VoidCallback onPressed;

  final bool following;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      type: following ? ButtonType.primary : ButtonType.outlined,
      tintColor: following ? null : context.theme.appColors.primaryAccent,
      label: Text(
        following ? context.i18n.button_following : context.i18n.button_follow,
        style: context.theme.appTextThemes.caption.copyWith(
          color: following
              ? context.theme.appColors.secondaryBackground
              : context.theme.appColors.primaryAccent,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(87.0.s, 28.0.s),
        padding: EdgeInsets.symmetric(horizontal: 15.0.s),
      ),
    );
  }
}
