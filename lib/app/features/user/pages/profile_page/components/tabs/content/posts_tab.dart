// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/empty_state.dart';
import 'package:ion/app/features/user/providers/user_posts_data_source_provider.dart';

class PostsTab extends ConsumerWidget {
  const PostsTab({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(userPostsDataSourceProvider(pubkey));
    final entities = ref.watch(entitiesPagedDataProvider(dataSource));

    if (entities == null) {
      return const EntitiesListSkeleton();
    }

    if (entities.data.items.isEmpty) {
      return const EmptyState();
    }

    return CustomScrollView(
      slivers: [EntitiesList(entities: entities.data.items.toList())],
    );
  }
}
