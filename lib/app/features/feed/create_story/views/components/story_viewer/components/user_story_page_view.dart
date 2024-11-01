import 'package:flutter/material.dart';
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
              StoryViewerContent(story: user.stories[currentStoryIndex]),
              StoryViewerHeader(currentStory: user.stories[currentStoryIndex]),
              StoryInputField(
                controller: textController,
                bottomPadding: bottomPadding,
              ),
              StoryViewerActionButtons(
                story: user.stories[currentStoryIndex],
                bottomPadding: bottomPadding,
              ),
              if (isKeyboardVisible)
                StoryReactionOverlay(
                  textController: textController,
                ),
              if (emojiState.showNotification && emojiState.selectedEmoji != null)
                StoryReactionNotification(
                  emoji: emojiState.selectedEmoji!,
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
