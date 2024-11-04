// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ion/app/features/feed/stories/data/models/models.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
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
    try {
      await Future<void>.delayed(const Duration(seconds: 1));

      final groupedStories = groupBy<Story, String>(
        stories,
        (Story story) => story.data.authorId,
      );

      return groupedStories.entries.map<UserStories>((MapEntry<String, List<Story>> entry) {
        final userStories = entry.value;
        final firstStory = userStories.first;

        return UserStories(
          userId: entry.key,
          userName: firstStory.data.author,
          userAvatar: firstStory.data.imageUrl,
          stories: userStories,
          isVerified: Random().nextBool(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch stories: $e');
    }
  }
}
