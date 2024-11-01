// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';
import 'package:ion/app/features/feed/create_story/providers/emoji_reaction_provider.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_input_field.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_reaction_notification.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_reaction_overlay.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_action_buttons.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_content.dart';
import 'package:ion/app/features/feed/create_story/views/components/story_viewer/components/story_viewer_header.dart';

class StoryContent extends HookConsumerWidget {
  const StoryContent({
    required this.story,
    required this.isVideoPlaying,
    super.key,
  });

  final Story story;
  final bool isVideoPlaying;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiState = ref.watch(emojiReactionsControllerProvider);
    final textController = useTextEditingController.fromValue(
      TextEditingValue.empty,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: Stack(
        fit: StackFit.expand,
        children: [
          StoryViewerContent(story: story),
          StoryViewerHeader(currentStory: story),
          KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              final bottomPadding =
                  isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom - 30.0.s : 16.0.s;

              return Stack(
                children: [
                  StoryInputField(
                    controller: textController,
                    bottomPadding: bottomPadding,
                  ),
                  StoryViewerActionButtons(
                    story: story,
                    bottomPadding: bottomPadding,
                  ),
                  if (isKeyboardVisible)
                    StoryReactionOverlay(
                      textController: textController,
                    ),
                ],
              );
            },
          ),
          if (emojiState.showNotification && emojiState.selectedEmoji != null)
            StoryReactionNotification(
              emoji: emojiState.selectedEmoji!,
            ),
        ],
      ),
    );
  }
}
