import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/providers/user_following_provider.dart';

class FollowUserButton extends ConsumerWidget {
  const FollowUserButton({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdSelectorProvider);
    final following = ref.watch(isCurrentUserFollowingSelectorProvider(userId));
    return Button(
      onPressed: () {
        ref.read(userFollowingProvider(currentUserId).notifier).toggleFollow(userId);
      },
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
