// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/follow_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/views/pages/unfollow_user_page.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class FollowUserButton extends ConsumerWidget {
  const FollowUserButton({
    required this.pubkey,
    this.followLabel,
    super.key,
  });

  final String pubkey;
  final String? followLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentUser = ref.watch(isCurrentUserSelectorProvider(pubkey));

    if (isCurrentUser) {
      return const SizedBox.shrink();
    }

    ref.displayErrors(followListManagerProvider); //TODO:test

    final following = ref.watch(isCurrentUserFollowingSelectorProvider(pubkey));
    return FollowButton(
      onPressed: () {
        if (following) {
          showSimpleBottomSheet<void>(
            context: context,
            child: UnfollowUserModal(
              pubkey: pubkey,
            ),
          );
        } else {
          ref.read(followListManagerProvider.notifier).toggleFollow(pubkey);
        }
      },
      following: following,
      followLabel: followLabel,
    );
  }
}
