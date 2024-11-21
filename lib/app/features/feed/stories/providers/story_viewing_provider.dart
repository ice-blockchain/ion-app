// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.g.dart';

@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  StoryViewerState build() => const StoryViewerState.initial();

  Future<void> loadStories({String? startingPubkey}) async {
    state = const StoryViewerState.loading();

    try {
      final stories = await _fetchUserStories();

      if (stories.isEmpty) {
        state = const StoryViewerState.error(message: 'No stories available');
        return;
      }

      var initialUserIndex = (startingPubkey != null)
          ? stories.indexWhere((story) => story.pubkey == startingPubkey)
          : -1;

      initialUserIndex = (initialUserIndex == -1) ? 0 : initialUserIndex;

      state = StoryViewerState.ready(
        userStories: stories,
        currentUserIndex: initialUserIndex,
        currentStoryIndex: 0,
      );
    } catch (e) {
      state = StoryViewerState.error(message: e.toString());
    }
  }

  void moveToNextStory() {
    state.whenOrNull(
      ready: (userStories, userIndex, storyIndex) {
        if (state.hasNextStory) {
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex,
            currentStoryIndex: storyIndex + 1,
          );
        } else if (state.hasNextUser) {
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex + 1,
            currentStoryIndex: 0,
          );
        } else {}
      },
    );
  }

  void moveToPreviousStory() {
    state.whenOrNull(
      ready: (userStories, userIndex, storyIndex) {
        if (state.hasPreviousStory) {
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex,
            currentStoryIndex: storyIndex - 1,
          );
        } else if (state.hasPreviousUser) {
          final previousUserStoriesCount = userStories[userIndex - 1].stories.length;
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex - 1,
            currentStoryIndex: previousUserStoriesCount - 1,
          );
        } else {}
      },
    );
  }

  void moveToUser(int userIndex) {
    state.whenOrNull(
      ready: (userStories, _, __) {
        if (userIndex >= 0 && userIndex < userStories.length) {
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex,
            currentStoryIndex: 0,
          );
        }
      },
    );
  }

  void moveToStoryIndex(int storyIndex) {
    state.whenOrNull(
      ready: (userStories, userIndex, _) {
        if (storyIndex >= 0 && storyIndex < userStories[userIndex].stories.length) {
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex,
            currentStoryIndex: storyIndex,
          );
        }
      },
    );
  }

  void moveToNextUser() {
    state.whenOrNull(
      ready: (userStories, userIndex, _) {
        if (state.hasNextUser) {
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex + 1,
            currentStoryIndex: 0,
          );
        }
      },
    );
  }

  void moveToPreviousUser() {
    state.whenOrNull(
      ready: (userStories, userIndex, _) {
        if (state.hasPreviousUser) {
          final previousUserStoriesCount = userStories[userIndex - 1].stories.length;
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex - 1,
            currentStoryIndex: previousUserStoriesCount - 1,
          );
        }
      },
    );
  }

  void moveToStory(int userIndex, int storyIndex) {
    state.whenOrNull(
      ready: (userStories, _, __) {
        final isValidUser = userIndex >= 0 && userIndex < userStories.length;
        final isValidStory =
            isValidUser && storyIndex >= 0 && storyIndex < userStories[userIndex].stories.length;

        if (isValidStory) {
          state = StoryViewerState.ready(
            userStories: userStories,
            currentUserIndex: userIndex,
            currentStoryIndex: storyIndex,
          );
        }
      },
    );
  }

  void toggleLike(String postId) {
    state.whenOrNull(
      ready: (userStories, userIndex, storyIndex) {
        final updatedUsers = userStories.map((user) {
          final updatedPosts = user.stories.map((post) {
            if (post.id == postId) {
              // TODO: wait for event from post is ready to be liked
            }
            return post;
          }).toList();

          return user.copyWith(stories: updatedPosts);
        }).toList();

        state = StoryViewerState.ready(
          userStories: updatedUsers,
          currentUserIndex: userIndex,
          currentStoryIndex: storyIndex,
        );
      },
    );
  }

  Future<List<UserStories>> _fetchUserStories() async {
    final dataSource = ref.watch(feedStoriesDataSourceProvider);
    final entitiesPagedDataState = ref.watch(entitiesPagedDataProvider(dataSource));

    final postEntities = entitiesPagedDataState?.data.items.whereType<PostEntity>().where((post) {
          final mediaType = post.data.media.values.firstOrNull?.mediaType;
          return mediaType == MediaType.image || mediaType == MediaType.video;
        }).toList() ??
        [];

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
}
