// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/feed_trending_videos_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/video/views/pages/videos_vertical_scroll_page.dart';

class TrendingVideosPage extends HookConsumerWidget {
  const TrendingVideosPage({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VideosVerticalScrollPage(
      eventReference: eventReference,
      getVideosData: () {
        final dataSource = ref.watch(feedTrendingVideosDataSourceProvider);
        return ref.watch(entitiesPagedDataProvider(dataSource));
      },
      onLoadMore: () => ref
          .read(
            entitiesPagedDataProvider(
              ref.read(feedTrendingVideosDataSourceProvider),
            ).notifier,
          )
          .fetchEntities(),
    );
  }
}
