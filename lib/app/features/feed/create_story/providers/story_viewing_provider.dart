// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/data/models/story_viewer_state.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.g.dart';

@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  StoryViewerState build() => const StoryViewerState.initial();

  Future<void> loadStories() async {
    state = const StoryViewerState.loading();

    final stories = await _fetchStories();

    if (stories.isEmpty) {
      state = const StoryViewerState.error(message: 'No stories available');
      return;
    }

    state = StoryViewerState.ready(
      stories: stories,
      currentIndex: 0,
    );
  }

  void moveToNextStory() {
    state.whenOrNull(
      ready: (stories, currentIndex) {
        if (currentIndex < stories.length - 1) {
          state = StoryViewerState.ready(
            stories: stories,
            currentIndex: currentIndex + 1,
          );
        }
      },
    );
  }

  void moveToPreviousStory() {
    state.whenOrNull(
      ready: (stories, currentIndex) {
        if (currentIndex > 0) {
          state = StoryViewerState.ready(
            stories: stories,
            currentIndex: currentIndex - 1,
          );
        }
      },
    );
  }

  void moveToStory(int index) {
    state.whenOrNull(
      ready: (stories, currentIndex) {
        if (index >= 0 && index < stories.length) {
          state = StoryViewerState.ready(
            stories: stories,
            currentIndex: index,
          );
        }
      },
    );
  }

  void toggleMute(String storyId) {
    state.whenOrNull(
      ready: (stories, currentIndex) {
        final updatedStories = stories.map((story) {
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

        state = StoryViewerState.ready(
          stories: updatedStories,
          currentIndex: currentIndex,
        );
      },
    );
  }

  void toggleLike(String storyId) {
    state.whenOrNull(
      ready: (stories, currentIndex) {
        final index = stories.indexWhere((story) => story.data.id == storyId);
        if (index != -1) {
          final story = stories[index];
          final liked = story.data.likeState == LikeState.liked;
          final updatedStory = story.copyWith(
            data: story.data.copyWith(
              likeState: liked ? LikeState.notLiked : LikeState.liked,
            ),
          );
          final updatedStories = List<Story>.from(stories);
          updatedStories[index] = updatedStory;
          state = StoryViewerState.ready(
            stories: updatedStories,
            currentIndex: currentIndex,
          );
        }
      },
    );
  }

  void updateProgress(String storyId, double progress) {
    state.whenOrNull(
      ready: (stories, currentIndex) {
        final updatedStories = stories.map((story) {
          if (story.data.id != storyId) return story;

          final updatedData = story.data.copyWith(
            progressState: ProgressState.inProgress(progress),
          );

          return story.copyWith(data: updatedData);
        }).toList();

        state = StoryViewerState.ready(
          stories: updatedStories,
          currentIndex: currentIndex,
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
