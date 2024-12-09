// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/stories/providers/emoji_reaction_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/header.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class StoryContent extends HookConsumerWidget {
  const StoryContent({
    required this.post,
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiState = ref.watch(emojiReactionsControllerProvider);
    final textController = useTextEditingController();
    final isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);

    useOnInit(
      () => ref.read(storyPauseControllerProvider.notifier).paused = isKeyboardVisible,
      [isKeyboardVisible],
    );

    final bottomPadding =
        isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom - 30.0.s : 16.0.s;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: Stack(
        fit: StackFit.expand,
        children: [
          StoryViewerContent(post: post),
          Stack(
            children: [
              const StoryHeaderGradient(),
              StoryViewerHeader(currentPost: post),
            ],
          ),
          Stack(
            children: [
              StoryInputField(
                controller: textController,
                bottomPadding: bottomPadding,
              ),
              StoryViewerActionButtons(
                post: post,
                bottomPadding: bottomPadding,
              ),
              if (isKeyboardVisible)
                StoryReactionOverlay(
                  textController: textController,
                ),
            ],
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
