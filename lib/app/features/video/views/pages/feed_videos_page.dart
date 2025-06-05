// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/feed_posts_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/video/views/pages/videos_vertical_scroll_page.dart';

class FeedVideosPage extends HookConsumerWidget {
  const FeedVideosPage({
    required this.eventReference,
    this.initialMediaIndex = 0,
    this.framedEventReference,
    super.key,
  });

  final EventReference eventReference;
  final EventReference? framedEventReference;
  final int initialMediaIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entities = ref.watch(feedPostsProvider.select((state) => state.items ?? {}));
    return VideosVerticalScrollPage(
      eventReference: eventReference,
      initialMediaIndex: initialMediaIndex,
      framedEventReference: framedEventReference,
      entities: entities,
      onLoadMore: () => ref.read(feedPostsProvider.notifier).fetchEntities(),
    );
  }
}
