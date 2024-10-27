// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/data/models/story_viewing_state.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.g.dart';

@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  StoryViewingState build() => const StoryViewingState.initial();

  Future<void> loadStories() async {
    state = const StoryViewingState.loading();

    try {
      final stories = await _fetchStories();

      if (stories.isEmpty) {
        state = const StoryViewingState.error(message: 'No stories available');
        return;
      }

      state = StoryViewingState.ready(
        stories: stories,
        currentIndex: 0,
      );
    } catch (e) {
      state = StoryViewingState.error(message: e.toString());
    }
  }

  void moveToNextStory() {
    state.mapOrNull(
      ready: (ready) {
        if (ready.currentIndex < ready.stories.length - 1) {
          state = StoryViewingState.ready(
            stories: ready.stories,
            currentIndex: ready.currentIndex + 1,
          );
        }
      },
    );
  }

  void moveToPreviousStory() {
    state.mapOrNull(
      ready: (ready) {
        if (ready.currentIndex > 0) {
          state = StoryViewingState.ready(
            stories: ready.stories,
            currentIndex: ready.currentIndex - 1,
          );
        }
      },
    );
  }

  void moveToStory(int index) {
    state.mapOrNull(
      ready: (ready) {
        if (index >= 0 && index < ready.stories.length) {
          state = StoryViewingState.ready(
            stories: ready.stories,
            currentIndex: index,
          );
        }
      },
    );
  }

  void toggleMute(String storyId) {
    state.mapOrNull(
      ready: (ready) {
        final updatedStories = ready.stories.map((story) {
          return story.map(
            image: (imageStory) => imageStory,
            video: (videoStory) {
              if (videoStory.data.id == storyId) {
                final isMuted = videoStory.muteState == MuteState.muted;
                return videoStory.copyWith(
                  muteState: isMuted ? MuteState.unmuted : MuteState.muted,
                );
              }
              return videoStory;
            },
          );
        }).toList();

        state = StoryViewingState.ready(
          stories: updatedStories,
          currentIndex: ready.currentIndex,
        );
      },
    );
  }

  void toggleLike(String storyId) {
    state.mapOrNull(
      ready: (ready) {
        final index = ready.stories.indexWhere((story) => story.data.id == storyId);
        if (index != -1) {
          final story = ready.stories[index];
          final liked = story.data.likeState == LikeState.liked;
          final updatedStory = story.copyWith(
            data: story.data.copyWith(
              likeState: liked ? LikeState.notLiked : LikeState.liked,
            ),
          );
          final updatedStories = List<Story>.from(ready.stories);
          updatedStories[index] = updatedStory;
          state = ready.copyWith(stories: updatedStories);
        }
      },
    );
  }

  void updateProgress(String storyId, double progress) {
    state.mapOrNull(
      ready: (ready) {
        final updatedStories = ready.stories.map((story) {
          if (story.data.id != storyId) return story;

          final updatedData = story.data.copyWith(
            progressState: ProgressState.inProgress(progress),
          );

          return story.copyWith(data: updatedData);
        }).toList();

        state = StoryViewingState.ready(
          stories: updatedStories,
          currentIndex: ready.currentIndex,
        );
      },
    );
  }

  Future<List<Story>> _fetchStories() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 1));

      final imageStories = stories.whereType<ImageStory>().take(2).toList();
      final videoStories = stories.whereType<VideoStory>().take(2).toList();

      return [
        ...imageStories,
        ...videoStories,
      ]..shuffle(Random());
    } catch (e) {
      throw Exception('Failed to fetch stories: $e');
    }
  }
}
