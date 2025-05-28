// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.c.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_provider.c.g.dart';

/// Provides a list of user stories grouped by the pubkey
///
/// The provider filters post entities to include only those with image or video media types
/// and groups them by the pubkey
@Riverpod(keepAlive: true)
List<UserStories>? stories(Ref ref) {
  final dataSource = ref.watch(feedStoriesDataSourceProvider);
  final entitiesPagedDataState = ref.watch(entitiesPagedDataProvider(dataSource));
  final entities = entitiesPagedDataState?.data.items;

  if (entities == null) return null;

  final postEntities = entities
      .whereType<ModifiablePostEntity>()
      .where((post) {
        final mediaType = post.data.media.values.firstOrNull?.mediaType;
        return mediaType == MediaType.image || mediaType == MediaType.video;
      })
      .sortedBy((post) => post.createdAt)
      .toList();

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

@riverpod
List<UserStories> filteredStoriesByPubkey(Ref ref, String pubkey) {
  final stories = ref.watch(storiesProvider) ?? [];
  final userIndex = stories.indexWhere((userStories) => userStories.pubkey == pubkey);

  if (userIndex == -1) return [];

  return stories.sublist(userIndex);
}

@riverpod
UserStories? userStoriesByPubkey(Ref ref, String pubkey) {
  final stories = ref.watch(storiesProvider) ?? [];
  final userIndex = stories.indexWhere((userStories) => userStories.pubkey == pubkey);

  if (userIndex == -1) return null;

  return stories[userIndex];
}
