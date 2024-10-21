// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/follow_button.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/user/providers/user_following_provider.dart';

class FollowUserButton extends ConsumerWidget {
  const FollowUserButton({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final following = ref.watch(isCurrentUserFollowingSelectorProvider(userId));
    return FollowButton(
      onPressed: () {
        ref.read(userFollowingProvider(currentUserId).notifier).toggleFollow(userId);
      },
      following: following,
    );
  }
}
