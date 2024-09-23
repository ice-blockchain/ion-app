import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/user/providers/followed_users_provider.dart';

class FollowUserButton extends ConsumerWidget {
  const FollowUserButton({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followed = ref.watch(isUserFollowedSelectorProvider(userId));
    return Button(
      onPressed: () {
        ref.read(followedUsersProvider.notifier).toggleFollow(userId);
      },
      type: followed ? ButtonType.primary : ButtonType.outlined,
      tintColor: followed ? null : context.theme.appColors.primaryAccent,
      label: Text(
        followed ? context.i18n.button_following : context.i18n.button_follow,
        style: context.theme.appTextThemes.caption.copyWith(
          color: followed
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
