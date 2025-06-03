// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/feed_trending_videos_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/video/views/pages/videos_vertical_scroll_page.dart';

class TrendingVideosPage extends HookConsumerWidget {
  const TrendingVideosPage({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entities = ref.watch(feedTrendingVideosProvider.select((state) => state.items ?? {}));
    return VideosVerticalScrollPage(
      eventReference: eventReference,
      entities: entities,
      onLoadMore: () => ref.read(feedTrendingVideosProvider.notifier).loadMore(),
    );
  }
}
