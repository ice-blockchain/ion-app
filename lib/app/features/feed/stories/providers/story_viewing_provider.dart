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

  Future<void> loadStories({String? startingPubkey}) async {
    state = const StoryViewerState.loading();

    try {
      final stories = await _fetchUserStories();

      if (stories.isEmpty) {
        state = const StoryViewerState.error(message: 'No stories available');
        return;
      }

      var initialUserIndex = (startingPubkey != null)
          ? stories.indexWhere((story) => story.userId == startingPubkey)
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

  void toggleMute(String storyId) {
    final currentStory = state.currentStory;
    if (currentStory == null) return;

    state.whenOrNull(
      ready: (userStories, userIndex, storyIndex) {
        final updatedUsers = userStories.map((userStory) {
          if (!userStory.hasStoryWithId(storyId)) return userStory;

          final updatedStories = userStory.stories
              .map(
                (story) => story.maybeWhen(
                  video: (post, muteState, likeState) => post.id == storyId
                      ? Story.video(
                          post: post,
                          muteState:
                              muteState == MuteState.muted ? MuteState.unmuted : MuteState.muted,
                          likeState: likeState,
                        )
                      : story,
                  orElse: () => story,
                ),
              )
              .toList();

          return userStory.copyWith(stories: updatedStories);
        }).toList();

        state = StoryViewerState.ready(
          userStories: updatedUsers,
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
      ready: (userStorie, userIndex, storyIndex) {
        final updatedUsers = userStorie.map((user) {
          if (!user.hasStoryWithId(storyId)) return user;

          final storyIndex = user.getStoryIndex(storyId);
          if (storyIndex == -1) return user;

          final story = user.stories[storyIndex];
          final updatedStories = [...user.stories];
          updatedStories[storyIndex] = story.when(
            image: (post, likeState) => Story.image(
              post: post,
              likeState: likeState == LikeState.liked ? LikeState.notLiked : LikeState.liked,
            ),
            video: (post, muteState, likeState) => Story.video(
              post: post,
              muteState: muteState,
              likeState: likeState == LikeState.liked ? LikeState.notLiked : LikeState.liked,
            ),
          );

          return user.copyWith(stories: updatedStories);
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
    final dataSource = ref.read(feedStoriesDataSourceProvider);
    final entitiesPagedDataState = ref.read(entitiesPagedDataProvider(dataSource));

    final postEntities = entitiesPagedDataState?.data.items.whereType<PostEntity>().where(
          (post) {
            final mediaAttachment = post.data.media.values.firstOrNull;
            return mediaAttachment != null && _isValidMediaType(mediaAttachment.mediaType);
          },
        ).toList() ??
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

      final userMetadata = await ref.read(userMetadataProvider(pubkey).future);

      final stories = userPosts.map((post) {
        final mediaAttachment = post.data.media.values.first;
        return mediaAttachment.mediaType == MediaType.image
            ? Story.image(post: post)
            : Story.video(post: post);
      }).toList();

      final userStories = UserStories(
        userId: pubkey,
        userName: userMetadata?.data.displayName ?? '',
        userAvatar: userMetadata?.data.picture ?? '',
        stories: stories,
        isVerified: userMetadata?.data.verified ?? false,
      );

      userStoriesList.add(userStories);
    }

    return userStoriesList;
  }

  bool _isValidMediaType(MediaType mediaType) =>
      mediaType == MediaType.image || mediaType == MediaType.video;
}
