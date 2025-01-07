// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/pages/new_chat_modal/components/new_chat_initial_view/new_chat_initial_view.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class FollowingUsersList extends ConsumerWidget {
  const FollowingUsersList({
    required this.onUserSelected,
    this.selectedPubkeys,
    this.isMultiple = false,
    super.key,
  });

  final void Function(UserMetadataEntity user) onUserSelected;
  final List<String>? selectedPubkeys;
  final bool isMultiple;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final following = ref.watch(currentUserFollowListProvider);
    final followers = following.valueOrNull?.data.list;
    final pubkeys = followers?.map((e) => e.pubkey).toList() ?? [];

    if (pubkeys.isEmpty) {
      return const NewChatInitialView();
    }

    return ListView.separated(
      itemBuilder: (context, index) {
        return _FollowingUserListItem(
          pubkey: pubkeys[index],
          onUserSelected: onUserSelected,
          selectedPubkeys: selectedPubkeys,
          isMultiple: isMultiple,
        );
      },
      itemCount: pubkeys.length,
      separatorBuilder: (context, index) => SizedBox(height: 14.0.s),
    );
  }
}

class _FollowingUserListItem extends ConsumerWidget {
  const _FollowingUserListItem({
    required this.pubkey,
    required this.onUserSelected,
    this.selectedPubkeys,
    this.isMultiple = false,
  });

  final String pubkey;
  final void Function(UserMetadataEntity user) onUserSelected;
  final List<String>? selectedPubkeys;
  final bool isMultiple;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('pubkey: $pubkey');
    final user = ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    final isSelected = selectedPubkeys?.contains(pubkey) ?? false;
    print(selectedPubkeys);
    return ListItem.user(
      onTap: () => onUserSelected(user!),
      title: Text(user?.data.displayName ?? ''),
      subtitle: Text(prefixUsername(username: user?.data.name ?? '', context: context)),
      profilePicture: user?.data.picture,
      trailing: !isMultiple
          ? null
          : isSelected
              ? Assets.svg.iconBlockCheckboxOnblue.icon(
                  color: context.theme.appColors.success,
                )
              : Assets.svg.iconBlockCheckboxOff.icon(
                  color: context.theme.appColors.tertararyText,
                ),
    );
  }
}
