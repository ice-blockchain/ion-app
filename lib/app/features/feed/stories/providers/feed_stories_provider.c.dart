// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_following_content_provider.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_stories_provider.c.g.dart';

@riverpod
class FeedStories extends _$FeedStories with DelegatedPagedNotifier {
  @override
  ({Iterable<UserStories>? items, bool hasMore}) build() {
    final filter = ref.watch(feedCurrentFilterProvider);
    if (filter.filter == FeedFilter.following) {
      final followingContent = ref.watch(feedFollowingContentProvider(FeedType.story));
      return (items: _groupByPubkey(followingContent.items), hasMore: followingContent.hasMore);
    } else {
      final dataSource = ref.watch(feedStoriesDataSourceProvider);
      final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
      return (
        items: _groupByPubkey(entitiesPagedData?.data.items),
        hasMore: entitiesPagedData?.hasMore ?? true
      );
    }
  }

  @override
  PagedNotifier getDelegate() {
    final filter = ref.watch(feedCurrentFilterProvider);
    if (filter.filter == FeedFilter.following) {
      return ref.read(feedFollowingContentProvider(FeedType.story).notifier);
    } else {
      final dataSource = ref.watch(feedStoriesDataSourceProvider);
      return ref.read(entitiesPagedDataProvider(dataSource).notifier);
    }
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
List<UserStories> feedStoriesByPubkey(Ref ref, String pubkey) {
  final stories = ref.watch(feedStoriesProvider.select((state) => state.items?.toList() ?? []));
  final userIndex = stories.indexWhere((userStories) => userStories.pubkey == pubkey);

  if (userIndex == -1) return [];

  return stories.sublist(userIndex);
}
