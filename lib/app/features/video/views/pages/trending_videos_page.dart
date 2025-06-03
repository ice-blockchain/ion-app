// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_following_content_provider.c.dart';
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
    final videos = ref.watch(
      feedFollowingContentProvider(FeedType.video, FeedModifier.trending)
          .select((state) => state.items ?? {}),
    );
    return VideosVerticalScrollPage(
      eventReference: eventReference,
      videos: videos,
      onLoadMore: () => ref
          .read(feedFollowingContentProvider(FeedType.video, FeedModifier.trending).notifier)
          .fetch(),
    );
  }
}
