// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/user/providers/user_following_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class FollowUserButton extends ConsumerWidget {
  const FollowUserButton({
    required this.userId,
    this.showIcon = false,
    super.key,
  });

  final String userId;
  final bool showIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final following = ref.watch(isCurrentUserFollowingSelectorProvider(userId));
    return Button(
      onPressed: () {
        ref.read(userFollowingProvider(currentUserId).notifier).toggleFollow(userId);
      },
      leadingIcon: showIcon == true
          ? (following ? Assets.svg.iconSearchFollowers : Assets.svg.iconSearchFollow).icon(
              color: !following
                  ? context.theme.appColors.onPrimaryAccent
                  : context.theme.appColors.primaryAccent,
              size: 16.0.s,
            )
          : null,
      type: !following ? ButtonType.primary : ButtonType.outlined,
      tintColor: !following ? null : context.theme.appColors.primaryAccent,
      label: Text(
        following ? context.i18n.button_following : context.i18n.button_follow,
        style: context.theme.appTextThemes.caption.copyWith(
          color: !following
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
