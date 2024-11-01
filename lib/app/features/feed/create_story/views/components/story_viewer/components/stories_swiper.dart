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
import 'package:ion/app/features/feed/create_story/providers/story_viewing_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_input_field.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_reaction_notification.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_reaction_overlay.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_action_buttons.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_content.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_header.dart';
import 'package:ion/app/features/feed/create_story/views/pages/story_viewer_page.dart';

class StoriesSwiper extends StatelessWidget {
  const StoriesSwiper({
    required this.userPageController,
    required this.users,
    required this.currentUserIndex,
    required this.currentStoryIndex,
    required this.onUserPageChanged,
    required this.onStoryPageChanged,
    required this.onNextStory,
    required this.onPreviousStory,
    super.key,
  });

  final PageController userPageController;
  final List<UserStories> users;
  final int currentUserIndex;
  final int currentStoryIndex;
  final ValueChanged<int> onUserPageChanged;
  final ValueChanged<int> onStoryPageChanged;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;

  @override
  Widget build(BuildContext context) {
    return CubePageView.builder(
      controller: userPageController,
      itemCount: users.length,
      onPageChanged: (index) {
        Future(() {
          onUserPageChanged(index);
        });
      },
      itemBuilder: (context, userIndex, userNotifier) {
        final user = users[userIndex];
        final isCurrentUser = userIndex == currentUserIndex;

        return CubeWidget(
          index: userIndex,
          pageNotifier: userNotifier,
          child: UserStoryPageView(
            user: user,
            isCurrentUser: isCurrentUser,
            currentStoryIndex: isCurrentUser ? currentStoryIndex : 0,
            onStoryPageChanged: (storyIndex) {
              if (isCurrentUser) {
                onStoryPageChanged(storyIndex);
              }
            },
            onNextStory: onNextStory,
            onPreviousStory: onPreviousStory,
          ),
        );
      },
    );
  }
}

class UserStoryPageView extends HookConsumerWidget {
  const UserStoryPageView({
    required this.user,
    required this.isCurrentUser,
    required this.currentStoryIndex,
    required this.onStoryPageChanged,
    required this.onNextStory,
    required this.onPreviousStory,
    super.key,
  });

  final UserStories user;
  final bool isCurrentUser;
  final int currentStoryIndex;
  final ValueChanged<int> onStoryPageChanged;
  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tapPosition = useState<Offset?>(null);
    final storyPageController = usePageControllerWithInitialPage(0);
    final textController = useTextEditingController.fromValue(
      TextEditingValue.empty,
    );

    final emojiState = ref.watch(emojiReactionsControllerProvider);

    useEffect(
      () {
        if (storyPageController.hasClients && isCurrentUser) {
          storyPageController.jumpToPage(currentStoryIndex);
        }
        return null;
      },
      [currentStoryIndex, isCurrentUser],
    );

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        final bottomPadding =
            isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom - 30.0.s : 16.0.s;

        return GestureDetector(
          onTapDown: (details) => tapPosition.value = details.globalPosition,
          onTap: () => _handleTap(
            context,
            tapPosition.value?.dx ?? 0,
            ref,
          ),
          onLongPress: () {
            if (user.stories[currentStoryIndex] is VideoStory) {
              ref
                  .read(videoControllerProvider(user.stories[currentStoryIndex].data.contentUrl))
                  .pause();
            }
          },
          onLongPressEnd: (_) {
            if (user.stories[currentStoryIndex] is VideoStory) {
              ref
                  .read(videoControllerProvider(user.stories[currentStoryIndex].data.contentUrl))
                  .play();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0.s),
                child: StoryViewerContent(story: user.stories[currentStoryIndex]),
              ),
              Positioned(
                top: 14.0.s,
                left: 16.0.s,
                right: 22.0.s,
                child: StoryViewerHeader(currentStory: user.stories[currentStoryIndex]),
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
                child: StoryViewerActionButtons(story: user.stories[currentStoryIndex]),
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
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, double tapX, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isLeftSide = tapX < screenWidth / 2;

    if (isLeftSide) {
      if (currentStoryIndex > 0) {
        onPreviousStory();
      } else {
        ref.read(storyViewingControllerProvider.notifier).moveToPreviousUser();
      }
    } else {
      if (currentStoryIndex < user.stories.length - 1) {
        onNextStory();
      } else {
        ref.read(storyViewingControllerProvider.notifier).moveToNextUser();
      }
    }
  }
}
