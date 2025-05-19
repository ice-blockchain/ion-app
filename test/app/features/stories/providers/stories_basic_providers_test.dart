// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/providers/emoji_reaction_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';

import '../../../../test_utils.dart';

void main() {
  group('StoryImageLoadStatus', () {
    const storyId = 'story_123';

    test('initial state is false, markLoaded() switches to true', () {
      final container = createContainer();

      expect(container.read(storyImageLoadStatusProvider(storyId)), isFalse);

      container.read(storyImageLoadStatusProvider(storyId).notifier).markLoaded();

      expect(container.read(storyImageLoadStatusProvider(storyId)), isTrue);
    });
  });

  group('StoryPause / StoryMenu controllers', () {
    test('pause flag toggles via setter', () {
      final container = createContainer();

      expect(container.read(storyPauseControllerProvider), isFalse);

      container.read(storyPauseControllerProvider.notifier).paused = true;
      expect(container.read(storyPauseControllerProvider), isTrue);
    });

    test('menuOpen flag toggles via setter', () {
      final container = createContainer();

      expect(container.read(storyMenuControllerProvider), isFalse);

      container.read(storyMenuControllerProvider.notifier).menuOpen = true;
      expect(container.read(storyMenuControllerProvider), isTrue);
    });
  });

  group('EmojiReactionsController', () {
    test('showReaction() sets emoji and notification flag', () {
      final container = createContainer();

      container.read(emojiReactionsControllerProvider.notifier).showReaction('😊');

      final state = container.read(emojiReactionsControllerProvider);
      expect(state.selectedEmoji, '😊');
      expect(state.showNotification, isTrue);
    });

    test('hideNotification() resets both fields', () {
      final container = createContainer();

      container.read(emojiReactionsControllerProvider.notifier).showReaction('🔥');
      container.read(emojiReactionsControllerProvider.notifier).hideNotification();

      final state = container.read(emojiReactionsControllerProvider);
      expect(state.selectedEmoji, isNull);
      expect(state.showNotification, isFalse);
    });
  });
}
