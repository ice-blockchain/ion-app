// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.m.dart';
import 'package:ion/app/features/feed/providers/feed_following_content_provider.m.dart';
import 'package:ion/app/features/feed/providers/feed_for_you_content_provider.m.dart';
import 'package:ion/app/features/feed/stories/data/models/story.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_stories_provider.r.g.dart';

@riverpod
class FeedStories extends _$FeedStories with DelegatedPagedNotifier {
  @override
  ({Iterable<UserStories>? items, bool hasMore}) build() {
    final filter = ref.watch(feedCurrentFilterProvider);
    final data = switch (filter.filter) {
      FeedFilter.following => ref.watch(feedFollowingContentProvider(FeedType.story)),
      FeedFilter.forYou => ref.watch(feedForYouContentProvider(FeedType.story)),
    };
    return (items: _groupByPubkey(data.items), hasMore: data.hasMore);
  }

  @override
  PagedNotifier getDelegate() {
    final filter = ref.read(feedCurrentFilterProvider);
    return switch (filter.filter) {
      FeedFilter.following => ref.read(feedFollowingContentProvider(FeedType.story).notifier),
      FeedFilter.forYou => ref.read(feedForYouContentProvider(FeedType.story).notifier),
    };
  }

  Iterable<UserStories>? _groupByPubkey(Iterable<IonConnectEntity>? entities) {
    if (entities == null) return null;

    final postEntities = entities.whereType<ModifiablePostEntity>().where((post) {
      final mediaType = post.data.media.values.firstOrNull?.mediaType;
      return mediaType == MediaType.image || mediaType == MediaType.video;
    }).sorted((a, b) => a.createdAt.compareTo(b.createdAt));

    final groupedStories = groupBy<ModifiablePostEntity, String>(
      postEntities,
      (post) => post.masterPubkey,
    );

    final userStoriesList = <UserStories>[];

    for (final entry in groupedStories.entries) {
      final pubkey = entry.key;
      final userPosts = entry.value;

      if (userPosts.isEmpty) continue;

      final userStories = UserStories(
        pubkey: pubkey,
        stories: userPosts,
      );

      userStoriesList.add(userStories);
    }

    return userStoriesList;
  }
}

@riverpod
List<UserStories> feedStoriesByPubkey(Ref ref, String pubkey, {bool showOnlySelectedUser = false}) {
  final stories = ref.watch(feedStoriesProvider.select((state) => state.items?.toList() ?? []));
  final userIndex = stories.indexWhere((userStories) => userStories.pubkey == pubkey);

  if (userIndex == -1) return [];

  if (showOnlySelectedUser) {
    return [stories[userIndex]];
  } else {
    return stories.sublist(userIndex);
  }
}
