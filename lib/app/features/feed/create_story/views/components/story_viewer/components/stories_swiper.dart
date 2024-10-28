// SPDX-License-Identifier: ice License 1.0

import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/providers/emoji_reaction_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_input_field.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_reaction_notification.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_reaction_overlay.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_action_buttons.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_content.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_header.dart';

class StoriesSwiper extends HookConsumerWidget {
  const StoriesSwiper({
    required this.stories,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final List<Story> stories;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController(initialPage: currentIndex);
    final previousIndex = useRef(currentIndex);
    final tapPosition = useState<Offset?>(null);
    final textController = useTextEditingController.fromValue(
      TextEditingValue.empty,
    );

    final emojiState = ref.watch(emojiReactionsControllerProvider);

    useEffect(
      () {
        if (currentIndex != previousIndex.value) {
          previousIndex.value = currentIndex;
          if (pageController.hasClients) {
            pageController.animateToPage(
              currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
        return null;
      },
      [currentIndex],
    );

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        final bottomPadding =
            isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom - 30.0.s : 16.0.s;

        return Stack(
          fit: StackFit.expand,
          children: [
            CubePageView.builder(
              controller: pageController,
              itemCount: stories.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index, notifier) {
                final story = stories[index];
                return CubeWidget(
                  index: index,
                  pageNotifier: notifier,
                  child: GestureDetector(
                    onTapDown: (details) => tapPosition.value = details.globalPosition,
                    onTap: () => _handleTap(
                      context,
                      tapPosition.value?.dx ?? 0,
                    ),
                    onLongPress: () {
                      if (story is VideoStory) {
                        ref.read(videoControllerProvider(story.data.contentUrl)).pause();
                      }
                    },
                    onLongPressEnd: (_) {
                      if (story is VideoStory) {
                        ref.read(videoControllerProvider(story.data.contentUrl)).play();
                      }
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0.s),
                          child: StoryViewerContent(story: story),
                        ),
                        Positioned(
                          top: 14.0.s,
                          left: 16.0.s,
                          right: 22.0.s,
                          child: StoryViewerHeader(currentStory: story),
                        ),
                        Positioned(
                          bottom: bottomPadding,
                          left: 16.0.s,
                          right: 70.0.s,
                          child: StoryInputField(
                            controller: textController,
                          ),
                        ),
                        Positioned(
                          bottom: bottomPadding,
                          right: 16.0.s,
                          child: StoryViewerActionButtons(story: story),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (isKeyboardVisible)
              StoryReactionOverlay(
                textController: textController,
              ),
            if (emojiState.showNotification && emojiState.selectedEmoji != null)
              Positioned(
                top: 70.0.s,
                left: 0.0.s,
                right: 0.0.s,
                child: Animate(
                  key: ValueKey(emojiState.selectedEmoji),
                  onComplete: (controller) {
                    ref.read(emojiReactionsControllerProvider.notifier).hideNotification();
                  },
                  effects: [
                    FadeEffect(duration: 300.ms),
                    ThenEffect(delay: 2.seconds),
                    FadeEffect(
                      begin: 1,
                      end: 0,
                      duration: 300.ms,
                    ),
                  ],
                  child: StoryReactionNotification(
                    emoji: emojiState.selectedEmoji!,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _handleTap(BuildContext context, double tapX) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLeftSide = tapX < screenWidth / 2;

    if (isLeftSide) {
      onPrevious();
    } else {
      onNext();
    }
  }
}
