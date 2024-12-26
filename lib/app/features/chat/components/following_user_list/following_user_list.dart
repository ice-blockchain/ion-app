// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/features/chat/views/pages/new_chat_modal/components/new_chat_initial_view/new_chat_initial_view.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';

class FollowingUsersList extends ConsumerWidget {
  const FollowingUsersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(currentUserFollowListProvider);
    final followers = following.valueOrNull?.data.list;
    final pubkeys = followers?.map((e) => e.pubkey).toList() ?? [];

    if (pubkeys.isEmpty) {
      return const NewChatInitialView();
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        final user = ref.watch(userMetadataProvider(pubkeys[index])).valueOrNull;

        return ListItem.user(
          title: Text(user?.data.displayName ?? ''),
          subtitle: Text(prefixUsername(username: user?.data.name ?? '', context: context)),
          profilePicture: user?.data.picture,
        );
      },
      itemCount: pubkeys.length,
    );
  }
}
