// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/data/models/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/selectable_user_list_item.dart';

class SearchedUsers extends ConsumerWidget {
  const SearchedUsers({
    required this.users,
    required this.onUserSelected,
    this.selectable = false,
    this.selectedPubkeys = const [],
    super.key,
  });

  final List<UserMetadataEntity>? users;
  final void Function(UserMetadataEntity user) onUserSelected;
  final bool selectable;
  final List<String> selectedPubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedUsers = users;

    if (searchedUsers == null) {
      return ListItemsLoadingState(
        padding: EdgeInsets.symmetric(vertical: 8.0.s),
        listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
      );
    }

    if (searchedUsers.isEmpty) {
      return const NothingIsFound();
    }

    return SliverList.builder(
      itemCount: searchedUsers.length,
      itemBuilder: (BuildContext context, int index) {
        final user = searchedUsers.elementAt(index);
        return SelectableUserListItem(
          pubkey: user.pubkey,
          masterPubkey: user.masterPubkey,
          onUserSelected: onUserSelected,
          selectedPubkeys: selectedPubkeys,
          selectable: selectable,
        );
      },
    );
  }
}
