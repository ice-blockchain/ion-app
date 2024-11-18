// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.g.dart';

@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  StoryViewerState build() => const StoryViewerState.initial();

  Future<void> loadStories() async {
    state = const StoryViewerState.loading();

    try {
      final users = await _fetchUserStories();

      if (users.isEmpty) {
        state = const StoryViewerState.error(message: 'No stories available');
        return;
      }

      state = StoryViewerState.ready(
        users: users,
        currentUserIndex: 0,
        currentStoryIndex: 0,
      );
    } catch (e) {
      state = StoryViewerState.error(message: e.toString());
    }
  }

  void moveToNextStory() {
    state.whenOrNull(
      ready: (users, userIndex, storyIndex) {
        if (state.hasNextStory) {
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex,
            currentStoryIndex: storyIndex + 1,
          );
        } else if (state.hasNextUser) {
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex + 1,
            currentStoryIndex: 0,
          );
        } else {}
      },
    );
  }

  void moveToPreviousStory() {
    state.whenOrNull(
      ready: (users, userIndex, storyIndex) {
        if (state.hasPreviousStory) {
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex,
            currentStoryIndex: storyIndex - 1,
          );
        } else if (state.hasPreviousUser) {
          final previousUserStoriesCount = users[userIndex - 1].stories.length;
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex - 1,
            currentStoryIndex: previousUserStoriesCount - 1,
          );
        } else {}
      },
    );
  }

  void moveToUser(int userIndex) {
    state.whenOrNull(
      ready: (users, _, __) {
        if (userIndex >= 0 && userIndex < users.length) {
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex,
            currentStoryIndex: 0,
          );
        }
      },
    );
  }

  void moveToStoryIndex(int storyIndex) {
    state.whenOrNull(
      ready: (users, userIndex, _) {
        final userStories = users[userIndex];
        if (storyIndex >= 0 && storyIndex < userStories.stories.length) {
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex,
            currentStoryIndex: storyIndex,
          );
        }
      },
    );
  }

  void moveToNextUser() {
    state.whenOrNull(
      ready: (users, userIndex, _) {
        if (state.hasNextUser) {
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex + 1,
            currentStoryIndex: 0,
          );
        }
      },
    );
  }

  void moveToPreviousUser() {
    state.whenOrNull(
      ready: (users, userIndex, _) {
        if (state.hasPreviousUser) {
          final previousUserStoriesCount = users[userIndex - 1].stories.length;
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex - 1,
            currentStoryIndex: previousUserStoriesCount - 1,
          );
        }
      },
    );
  }

  void moveToStory(int userIndex, int storyIndex) {
    state.whenOrNull(
      ready: (users, _, __) {
        final isValidUser = userIndex >= 0 && userIndex < users.length;
        final isValidStory =
            isValidUser && storyIndex >= 0 && storyIndex < users[userIndex].stories.length;

        if (isValidStory) {
          state = StoryViewerState.ready(
            users: users,
            currentUserIndex: userIndex,
            currentStoryIndex: storyIndex,
          );
        }
      },
    );
  }

  void toggleMute(String storyId) {
    final currentStory = state.currentStory;
    if (currentStory == null) return;

    state.whenOrNull(
      ready: (users, userIndex, storyIndex) {
        final updatedUsers = users.map((user) {
          if (!user.hasStoryWithId(storyId)) return user;

          final updatedStories = user.stories
              .map(
                (story) => story.map(
                  image: (image) => image,
                  video: (video) => video.data.id == storyId
                      ? video.copyWith(
                          muteState: video.muteState == MuteState.muted
                              ? MuteState.unmuted
                              : MuteState.muted,
                        )
                      : video,
                ),
              )
              .toList();

          return user.copyWith(stories: updatedStories);
        }).toList();

        state = StoryViewerState.ready(
          users: updatedUsers,
          currentUserIndex: userIndex,
          currentStoryIndex: storyIndex,
        );
      },
    );
  }

  void toggleLike(String storyId) {
    final currentStory = state.currentStory;
    if (currentStory == null) return;

    state.whenOrNull(
      ready: (users, userIndex, storyIndex) {
        final updatedUsers = users.map((user) {
          if (!user.hasStoryWithId(storyId)) return user;

          final storyIndex = user.getStoryIndex(storyId);
          if (storyIndex == -1) return user;

          final story = user.stories[storyIndex];
          final updatedStories = [...user.stories];
          updatedStories[storyIndex] = story.copyWith(
            data: story.data.copyWith(
              likeState:
                  story.data.likeState == LikeState.liked ? LikeState.notLiked : LikeState.liked,
            ),
          );

          return user.copyWith(stories: updatedStories);
        }).toList();

        state = StoryViewerState.ready(
          users: updatedUsers,
          currentUserIndex: userIndex,
          currentStoryIndex: storyIndex,
        );
      },
    );
  }

  Future<List<UserStories>> _fetchUserStories() async {
    final dataSource = ref.read(feedStoriesDataSourceProvider);

    final entitiesPagedDataState = ref.read(entitiesPagedDataProvider(dataSource));

    final postEntities = entitiesPagedDataState?.data.items
        .whereType<PostEntity>()
        .where((post) => post.data.media.isNotEmpty)
        .toList();

    final groupedStories = groupBy<PostEntity, String>(
      postEntities ?? [],
      (post) => post.pubkey,
    );

    final userStoriesList = <UserStories>[];

    for (final entry in groupedStories.entries) {
      final pubkey = entry.key;
      final userPosts = entry.value;

      final userMetadata = await ref.read(userMetadataProvider(pubkey).future);

      final validPosts = userPosts.where((post) {
        final mediaAttachment = post.data.media.values.firstOrNull;
        return mediaAttachment != null && _isValidMediaType(mediaAttachment.mediaType);
      }).toList();

      if (validPosts.isEmpty) continue;

      final userStories = UserStories.fromPosts(
        pubkey,
        validPosts,
        userMetadata?.data,
      );
      userStoriesList.add(userStories);
    }

    return userStoriesList;
  }

  bool _isValidMediaType(MediaType mediaType) {
    return mediaType == MediaType.image || mediaType == MediaType.video;
  }
}
