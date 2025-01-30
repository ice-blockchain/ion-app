// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/no_user_view.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/selectable_user_list_item.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';

class FollowingUsers extends ConsumerWidget {
  const FollowingUsers({
    required this.onUserSelected,
    this.selectedPubkeys = const [],
    this.selectable = false,
    super.key,
  });

  final void Function(UserMetadataEntity user) onUserSelected;
  final List<String> selectedPubkeys;
  final bool selectable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followList = ref.watch(currentUserFollowListProvider);

    return followList.maybeWhen(
      data: (data) {
        final pubkeys = data?.data.list.map((e) => e.pubkey).toList() ?? [];
        return ListView.separated(
          itemBuilder: (context, index) {
            return SelectableUserListItem(
              pubkey: pubkeys[index],
              masterPubkey: pubkeys[index],
              onUserSelected: onUserSelected,
              selectedPubkeys: selectedPubkeys,
              selectable: selectable,
            );
          },
          itemCount: pubkeys.length,
          separatorBuilder: (context, index) => SizedBox(height: 14.0.s),
        );
      },
      orElse: () => const NoUserView(),
    );
  }
}
