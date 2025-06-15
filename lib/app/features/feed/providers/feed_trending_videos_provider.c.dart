// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_following_content_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_for_you_content_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_trending_videos_provider.c.g.dart';

@riverpod
class FeedTrendingVideos extends _$FeedTrendingVideos with DelegatedPagedNotifier {
  @override
  ({Iterable<IonConnectEntity>? items, bool hasMore}) build() {
    final filter = ref.watch(feedCurrentFilterProvider);
    final data = switch (filter.filter) {
      FeedFilter.following => ref
          .watch(feedFollowingContentProvider(FeedType.video, feedModifier: FeedModifier.trending)),
      FeedFilter.forYou =>
        ref.watch(feedForYouContentProvider(FeedType.video, feedModifier: FeedModifier.trending)),
    };
    return (items: data.items, hasMore: data.hasMore);
  }

  @override
  PagedNotifier getDelegate() {
    final filter = ref.read(feedCurrentFilterProvider);
    return switch (filter.filter) {
      FeedFilter.following => ref.read(
          feedFollowingContentProvider(FeedType.video, feedModifier: FeedModifier.trending)
              .notifier,
        ),
      FeedFilter.forYou => ref.read(
          feedForYouContentProvider(FeedType.video, feedModifier: FeedModifier.trending).notifier,
        ),
    };
  }
}
