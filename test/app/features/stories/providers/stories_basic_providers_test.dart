// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/story_reply_notification_provider.m.dart';

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

      container
          .read(storyReplyNotificationControllerProvider.notifier)
          .showNotification(emoji: '😊');

      final state = container.read(storyReplyNotificationControllerProvider);
      expect(state.selectedEmoji, '😊');
      expect(state.showNotification, isTrue);
    });

    test('hideNotification() resets both fields', () {
      final container = createContainer();

      container
          .read(storyReplyNotificationControllerProvider.notifier)
          .showNotification(emoji: '🔥');
      container.read(storyReplyNotificationControllerProvider.notifier).hideNotification();

      final state = container.read(storyReplyNotificationControllerProvider);
      expect(state.selectedEmoji, isNull);
      expect(state.showNotification, isFalse);
    });
  });
}
