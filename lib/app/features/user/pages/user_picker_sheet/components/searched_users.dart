// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/selectable_user_list_item.dart';
import 'package:ion/app/features/user/providers/search_users_data_source_provider.c.dart';

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
    final masterPubkey = ref.watch(currentPubkeySelectorProvider);
    final dataSource = ref.watch(searchUsersDataSourceProvider).valueOrNull;
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    // TODO: https://github.com/ice-blockchain/ion-app/pull/617#discussion_r1935389058
    final users = entitiesPagedData?.data.items
        ?.whereType<UserMetadataEntity>()
        .whereNot((user) => user.masterPubkey == masterPubkey)
        .toList();

    return LoadMoreBuilder(
      slivers: [
        SliverList.separated(
          separatorBuilder: (BuildContext _, int __) => SizedBox(height: 8.0.s),
          itemCount: users?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            final user = users?.elementAt(index);
            if (user == null) return const SizedBox.shrink();
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
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
      hasMore: entitiesPagedData?.hasMore ?? false,
    );
  }
}
