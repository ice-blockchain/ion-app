// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewing_provider.g.dart';

@riverpod
class StoryViewingController extends _$StoryViewingController {
  @override
  AsyncValue<List<Story>> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadStories() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await Future<void>.delayed(const Duration(seconds: 1));

        final imageStories = stories.whereType<ImageStory>().take(2).toList();
        final videoStories = stories.whereType<VideoStory>().take(2).toList();

        return [
          ...imageStories,
          ...videoStories,
        ]..shuffle(Random());
      },
    );
  }

  void toggleLike(String storyId) {
    state = state.maybeWhen(
      orElse: () => state,
      data: (stories) {
        final updatedStories = stories.map((story) {
          if (story.data.id != storyId) return story;

          final liked = story.data.likeState == LikeState.liked;

          final updatedData = story.data.copyWith(
            likeState: liked ? LikeState.notLiked : LikeState.liked,
          );

          return story.copyWith(data: updatedData);
        }).toList();
        return AsyncValue.data(updatedStories);
      },
    );
  }

  void toggleMute(String storyId) {
    state = state.maybeWhen(
      orElse: () => state,
      data: (stories) {
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
        return AsyncValue.data(updatedStories);
      },
    );
  }

  void updateProgress(String storyId, double progress) {
    state = state.maybeWhen(
      orElse: () => state,
      data: (stories) {
        final updatedStories = stories.map((story) {
          if (story.data.id != storyId) return story;

          final updatedData = story.data.copyWith(
            progressState: ProgressState.inProgress(progress),
          );

          return story.copyWith(data: updatedData);
        }).toList();
        return AsyncValue.data(updatedStories);
      },
    );
  }
}
