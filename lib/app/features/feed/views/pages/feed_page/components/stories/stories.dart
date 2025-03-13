// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/stories_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.c.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_item_content.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_skeleton.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class Stories extends HookConsumerWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(storiesProvider);

    useOnInit(
      () async {
        if (stories != null && stories.isNotEmpty) {
          stories
              .expand((userStory) => userStory.stories)
              .map((story) => story.data.primaryMedia)
              .where((media) => media != null && media.mediaType == MediaType.image)
              .map((media) => media!.url)
              .forEach((url) async => ref.read(storyImageCacheManagerProvider).downloadFile(url));
        }
      },
      [stories],
    );

    useOnInit(() {
      if (stories != null) {
        final allIds =
            stories.expand((userStory) => userStory.stories).map((story) => story.id).toSet();

        ref.read(viewedStoriesControllerProvider.notifier).syncAvailableStories(allIds.toList());
      }
    });

    final storyHasMore = ref.watch(
      entitiesPagedDataProvider(ref.watch(feedStoriesDataSourceProvider))
          .select((state) => (state?.hasMore).falseOrValue),
    );

    return Column(
      children: [
        SizedBox(height: 3.0.s),
        if (stories == null)
          const StoryListSkeleton()
        else
          LoadMoreBuilder(
            slivers: [
              StoryList(
                pubkeys: stories.map((story) => story.pubkey).toList(),
              ),
            ],
            hasMore: storyHasMore,
            onLoadMore: () => _onLoadMore(ref),
            builder: (context, slivers) {
              return SizedBox(
                height: StoryItemContent.height,
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  slivers: slivers,
                ),
              );
            },
          ),
        SizedBox(height: 16.0.s),
        FeedListSeparator(height: 12.0.s),
      ],
    );
  }

  Future<void> _onLoadMore(WidgetRef ref) async {
    await ref
        .read(entitiesPagedDataProvider(ref.read(feedStoriesDataSourceProvider)).notifier)
        .fetchEntities();
  }
}
