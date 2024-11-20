// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_skeleton.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';

class Stories extends ConsumerWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(feedStoriesDataSourceProvider);
    final storiesData = ref.watch(entitiesPagedDataProvider(dataSource));

    return Column(
      children: [
        SizedBox(height: 3.0.s),
        if (storiesData == null)
          const StoryListSkeleton()
        else
          LoadMoreBuilder(
            slivers: [
              StoryList(
                pubkeys: storiesData.data.items
                    .whereType<PostEntity>()
                    .where((entity) => entity.data.media.isNotEmpty)
                    .map((entity) => entity.pubkey)
                    .toSet()
                    .toList(),
              ),
            ],
            hasMore: storiesData.hasMore,
            onLoadMore: () => _onLoadMore(ref),
            builder: (context, slivers) {
              return SizedBox(
                height: StoryListItem.height,
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  slivers: slivers,
                ),
              );
            },
          ),
        SizedBox(height: 16.0.s),
      ],
    );
  }

  Future<void> _onLoadMore(WidgetRef ref) async {
    await ref
        .read(entitiesPagedDataProvider(ref.read(feedStoriesDataSourceProvider)).notifier)
        .fetchEntities();
  }
}
