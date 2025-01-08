// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/no_user_view.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class FollowingUsers extends ConsumerWidget {
  const FollowingUsers({
    required this.onUserSelected,
    this.selectedPubkeys,
    this.selectable = false,
    super.key,
  });

  final void Function(UserMetadataEntity user) onUserSelected;
  final List<String>? selectedPubkeys;
  final bool selectable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followListFuture =
        ref.watch(currentUserFollowListProvider.selectAsync((following) => following?.data.list));

    return FutureBuilder(
      future: followListFuture,
      builder: (data, snapshot) {
        if (snapshot.hasData) {
          final pubkeys = snapshot.data?.map((e) => e.pubkey).toList() ?? [];
          return ListView.separated(
            itemBuilder: (context, index) {
              return _FollowingUserListItem(
                pubkey: pubkeys[index],
                onUserSelected: onUserSelected,
                selectedPubkeys: selectedPubkeys,
                selectable: selectable,
              );
            },
            itemCount: pubkeys.length,
            separatorBuilder: (context, index) => SizedBox(height: 14.0.s),
          );
        }
        return const NoUserView();
      },
    );
  }
}

class _FollowingUserListItem extends ConsumerWidget {
  const _FollowingUserListItem({
    required this.pubkey,
    required this.onUserSelected,
    this.selectedPubkeys,
    this.selectable = false,
  });

  final String pubkey;
  final void Function(UserMetadataEntity user) onUserSelected;
  final List<String>? selectedPubkeys;
  final bool selectable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    final isSelected = selectedPubkeys?.contains(pubkey) ?? false;
    return ListItem.user(
      onTap: () => onUserSelected(user!),
      title: Text(user?.data.displayName ?? ''),
      subtitle: Text(prefixUsername(username: user?.data.name ?? '', context: context)),
      profilePicture: user?.data.picture,
      trailing: !selectable
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
