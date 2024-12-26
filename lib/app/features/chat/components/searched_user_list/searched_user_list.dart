// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/users_data_source_provider.c.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/utils/username.dart';

class SearchedUsersList extends ConsumerWidget {
  const SearchedUsersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(usersDataSourceProvider);
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final users = entitiesPagedData?.data.items?.whereType<UserMetadataEntity>().toList();
    final slivers = [
      if (users == null || users.isEmpty)
        const SliverToBoxAdapter(child: SizedBox.shrink())
      else
        SliverList.separated(
          separatorBuilder: (BuildContext _, int __) => SizedBox(height: 8.0.s),
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            final user = users.elementAt(index);
            return ListItem.user(
              title: Text(user.data.displayName),
              subtitle: Text(prefixUsername(username: user.data.name, context: context)),
              profilePicture: user.data.picture,
            );
          },
        ),
    ];

    return LoadMoreBuilder(
      slivers: slivers,
      builder: (context, slivers) => CustomScrollView(
        key: const ValueKey('paged_users_scroll_view'),
        slivers: slivers,
      ),
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
      hasMore: entitiesPagedData?.hasMore ?? true,
    );
  }
}
