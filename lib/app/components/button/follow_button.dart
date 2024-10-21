// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
<<<<<<< HEAD:lib/app/features/components/follow_user_button/follow_user_button.dart
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/core/views/pages/unfollow_user_page.dart';
import 'package:ion/app/features/user/providers/user_following_provider.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';
=======
>>>>>>> 86126d81 (feat = add contentCreatorsProvider):lib/app/components/button/follow_user_button.dart

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
      leadingIcon: (following ? Assets.svg.iconSearchFollowers : Assets.svg.iconSearchFollow).icon(
        color: following
            ? context.theme.appColors.primaryAccent
            : context.theme.appColors.onPrimaryAccent,
        size: 16.0.s,
      ),
      type: following ? ButtonType.outlined : ButtonType.primary,
      tintColor: following ? context.theme.appColors.primaryAccent : null,
      label: Text(
        following ? context.i18n.button_following : context.i18n.button_follow,
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
