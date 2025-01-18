// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/no_user_view.dart';
import 'package:ion/app/features/user/pages/user_picker_sheet/components/selectable_user_list_item.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.c.dart';

class FollowerUsers extends ConsumerWidget {
  const FollowerUsers({
    required this.onUserSelected,
    this.selectable = false,
    this.selectedPubkeys,
    super.key,
  });

  final void Function(UserMetadataEntity user) onUserSelected;
  final bool selectable;
  final List<String>? selectedPubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;
    final dataSource = ref.watch(followersDataSourceProvider(pubkey!));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final users = entitiesPagedData?.data.items?.whereType<UserMetadataEntity>().toList();

    if (users == null || users.isEmpty) return const NoUserView();

    final slivers = [
      SliverList.separated(
        separatorBuilder: (BuildContext _, int __) => SizedBox(height: 8.0.s),
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users.elementAt(index);
          return SelectableUserListItem(
            pubkey: user.masterPubkey,
            onUserSelected: onUserSelected,
            selectedPubkeys: selectedPubkeys,
            selectable: selectable,
          );
        },
      ),
    ];

    return LoadMoreBuilder(
      slivers: slivers,
      builder: (context, slivers) => CustomScrollView(
        key: const ValueKey('paged_followers_scroll_view'),
        slivers: slivers,
      ),
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
      hasMore: entitiesPagedData?.hasMore ?? false,
    );
  }
}
