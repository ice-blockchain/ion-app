// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_skeleton.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class Stories extends HookConsumerWidget {
  const Stories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(feedStoriesDataSourceProvider);
    final storiesData = ref.watch(entitiesPagedDataProvider(dataSource));

    useOnInit(
      () {
        if (dataSource != null) {
          ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
        }
      },
      [dataSource],
    );
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16.0.s,
        top: 3.0.s,
      ),
      child: storiesData == null
          ? const StoryListSkeleton()
          : StoryList(entities: storiesData.data.items.toList()),
    );
  }
}
