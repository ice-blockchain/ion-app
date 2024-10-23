// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/follow_button.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/core/views/pages/unfollow_user_page.dart';
import 'package:ion/app/features/user/providers/user_following_provider.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class FollowUserButton extends ConsumerWidget {
  const FollowUserButton({
    required this.pubKey,
    super.key,
  });

  final String pubKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
    final following = ref.watch(isCurrentUserFollowingSelectorProvider(pubKey));
    return FollowButton(
      onPressed: () {
        if (following) {
          showSimpleBottomSheet<void>(
            context: context,
            child: UnfollowUserModal(
              pubkey: pubKey,
            ),
          );
        } else {
          ref.read(userFollowingProvider(identityKeyName).notifier).toggleFollow(pubKey);
        }
      },
      following: following,
    );
  }
}
