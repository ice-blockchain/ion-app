// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/search/providers/feed_search_top_posts_provider.c.dart';
import 'package:ion/app/features/search/views/components/nothing_is_found/nothing_is_found.dart';

class FeedAdvancedSearchTop extends HookConsumerWidget {
  const FeedAdvancedSearchTop({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final topPostsSearchResults = ref.watch(feedSearchTopPostsProvider(query));

    return topPostsSearchResults.maybeWhen(
      data: (entities) {
        if (entities == null || entities.isEmpty) {
          return NothingIsFound(
            title: context.i18n.search_nothing_found,
          );
        }
        return CustomScrollView(slivers: [EntitiesList(entities: entities)]);
      },
      orElse: () => const CustomScrollView(slivers: [EntitiesListSkeleton()]),
    );
  }
}
