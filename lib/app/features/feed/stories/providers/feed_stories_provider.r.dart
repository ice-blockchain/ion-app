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
import 'package:ion/app/features/feed/stories/data/models/user_story.f.dart';
import 'package:ion/app/features/feed/stories/providers/current_user_story_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/stories_count_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_stories_provider.r.g.dart';

@riverpod
class FeedStories extends _$FeedStories with DelegatedPagedNotifier {
  @override
  ({Iterable<UserStory>? items, bool hasMore}) build() {
    final filter = ref.watch(feedCurrentFilterProvider);
    final currentUserStory = ref.watch(currentUserStoryProvider);
    final data = switch (filter.filter) {
      FeedFilter.following => ref.watch(
          feedFollowingContentProvider(FeedType.story)
              .select((data) => (items: data.items, hasMore: data.hasMore)),
        ),
      FeedFilter.forYou => ref.watch(
          feedForYouContentProvider(FeedType.story)
              .select((data) => (items: data.items, hasMore: data.hasMore)),
        ),
    };

    Iterable<UserStory>? stories;
    _userStories(data.items).then((userStories) {
      stories = userStories;
      if (currentUserStory != null) {
        stories = {currentUserStory, ...?stories};
      }

      state = (items: stories, hasMore: data.hasMore);
    });

    return stateOrNull ?? (items: null, hasMore: true);
  }

  @override
  PagedNotifier getDelegate() {
    final filter = ref.read(feedCurrentFilterProvider);
    return switch (filter.filter) {
      FeedFilter.following => ref.read(feedFollowingContentProvider(FeedType.story).notifier),
      FeedFilter.forYou => ref.read(feedForYouContentProvider(FeedType.story).notifier),
    };
  }

  Future<Iterable<UserStory>?> _userStories(Iterable<IonConnectEntity>? entities) async {
    if (entities == null) return null;

    final postEntities = entities.whereType<ModifiablePostEntity>().where((post) {
      final mediaType = post.data.media.values.firstOrNull?.mediaType;
      return mediaType == MediaType.image || mediaType == MediaType.video;
    });

    final userStoriesMap = <String, UserStory>{};

    for (final post in postEntities) {
      final pubkey = post.masterPubkey;

      if (userStoriesMap.containsKey(pubkey)) {
        continue;
      }

      // preload stories count
      ref.read(storiesCountProvider(pubkey));

      final userStory = UserStory(
        pubkey: pubkey,
        story: post,
      );

      userStoriesMap[pubkey] = userStory;
    }

    return userStoriesMap.values;
  }
}

@riverpod
List<UserStory> feedStoriesByPubkey(Ref ref, String pubkey, {bool showOnlySelectedUser = false}) {
  final stories = ref.watch(feedStoriesProvider.select((state) => state.items?.toList() ?? []));
  final userIndex = stories.indexWhere((userStories) => userStories.pubkey == pubkey);

  if (userIndex == -1) return [];

  if (showOnlySelectedUser) {
    return [stories[userIndex]];
  } else {
    return stories.sublist(userIndex);
  }
}
