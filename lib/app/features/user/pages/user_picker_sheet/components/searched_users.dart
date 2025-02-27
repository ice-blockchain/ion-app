// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/selectable_user_list_item.dart';
import 'package:ion/app/features/user/providers/search_users_provider.c.dart';

class SearchedUsers extends ConsumerWidget {
  const SearchedUsers({
    required this.onUserSelected,
    this.selectable = false,
    this.selectedPubkeys = const [],
    super.key,
  });

  final void Function(UserMetadataEntity user) onUserSelected;
  final bool selectable;
  final List<String> selectedPubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchUsersQueryProvider);
    final searchResults = ref.watch(searchUsersProvider(query: query));

    if (searchResults == null) {
      return const SizedBox.shrink();
    }

    return LoadMoreBuilder(
      slivers: [
        SliverList.separated(
          separatorBuilder: (BuildContext _, int __) => SizedBox(height: 8.0.s),
          itemCount: searchResults.users.length,
          itemBuilder: (BuildContext context, int index) {
            final user = searchResults.users.elementAt(index);
            return SelectableUserListItem(
              pubkey: user.pubkey,
              masterPubkey: user.masterPubkey,
              onUserSelected: onUserSelected,
              selectedPubkeys: selectedPubkeys,
              selectable: selectable,
            );
          },
        ),
      ],
      builder: (context, slivers) => CustomScrollView(
        slivers: slivers,
      ),
      onLoadMore: ref.read(searchUsersProvider(query: query).notifier).loadMore,
      hasMore: searchResults.hasMore,
    );
  }
}
