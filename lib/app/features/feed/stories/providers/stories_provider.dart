// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stories_provider.g.dart';

/// Provides a list of user stories grouped by the pubkey
///
/// The provider filters post entities to include only those with image or video media types
/// and groups them by the pubkey
@riverpod
List<UserStories>? stories(Ref ref) {
  final dataSource = ref.watch(feedStoriesDataSourceProvider);
  final entitiesPagedDataState = ref.watch(entitiesPagedDataProvider(dataSource));

  if (entitiesPagedDataState == null) return null;

  final postEntities = entitiesPagedDataState.data.items.whereType<PostEntity>().where((post) {
    final mediaType = post.data.media.values.firstOrNull?.mediaType;
    return mediaType == MediaType.image || mediaType == MediaType.video;
  }).toList();

  final groupedStories = groupBy<PostEntity, String>(
    postEntities,
    (post) => post.pubkey,
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