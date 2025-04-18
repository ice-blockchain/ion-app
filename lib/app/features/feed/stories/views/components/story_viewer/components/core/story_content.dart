// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/can_reply_notifier.c.dart';
import 'package:ion/app/features/feed/stories/providers/emoji_reaction_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_reply_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/header.dart';

class StoryContent extends HookConsumerWidget {
  const StoryContent({
    required this.story,
    super.key,
  });

  final ModifiablePostEntity story;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiState = ref.watch(emojiReactionsControllerProvider);
    final textController = useTextEditingController();
    final isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    final canReply = ref.watch(canReplyProvider(story.toEventReference())).valueOrNull ?? false;
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);
    final isCurrentUserStory = currentPubkey == story.masterPubkey;

    ref.listen(
      storyReplyProvider,
      (_, next) => ref.read(storyPauseControllerProvider.notifier).paused = next.isLoading,
    );

    final bottomPadding =
        isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom + 16.0.s : 16.0.s;

    final onSubmitted = useCallback(
      (String? content) async {
        if (content == null || content.isEmpty) return;

        final text = textController.text;

        textController.clear();

        FocusScope.of(context).unfocus();

        await ref.read(storyReplyProvider.notifier).sendReply(
              story,
              replyText: text,
            );
      },
      [story.masterPubkey],
    );

    final isPaused = ref.watch(storyPauseControllerProvider);
    final isReplyLoading = ref.watch(storyReplyProvider).isLoading;
    final isMenuOpen = ref.watch(storyMenuControllerProvider);

    final shouldShowElements = isReplyLoading || !isPaused || isMenuOpen || isKeyboardVisible;

    return ClipRRect(
      borderRadius: isKeyboardVisible
          ? BorderRadiusDirectional.only(
              topStart: Radius.circular(16.0.s),
              topEnd: Radius.circular(16.0.s),
            )
          : BorderRadius.circular(16.0.s),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            fit: StackFit.expand,
            children: [
              StoryViewerContent(post: story),
              if (isReplyLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Center(
                    child: IONLoadingIndicator(size: Size.square(54.0.s)),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              const StoryHeaderGradient(),
              StoryViewerHeader(currentPost: story),
            ],
          )
              .animate(target: shouldShowElements ? 1 : 0)
              .fade(duration: 300.ms)
              .slideY(begin: -0.1, end: 0, duration: 300.ms),
          Stack(
            children: [
              if (canReply && !isCurrentUserStory)
                StoryInputField(
                  controller: textController,
                  bottomPadding: bottomPadding,
                  onSubmitted: onSubmitted,
                ),
              StoryViewerActionButtons(
                post: story,
                bottomPadding: bottomPadding,
              ),
              if (isKeyboardVisible)
                StoryReactionOverlay(
                  story: story,
                  textController: textController,
                ),
            ],
          )
              .animate(target: shouldShowElements ? 1 : 0)
              .fade(duration: 300.ms)
              .slideY(begin: 0.1, end: 0, duration: 300.ms),
          if (emojiState.showNotification && emojiState.selectedEmoji != null)
            StoryReactionNotification(
              emoji: emojiState.selectedEmoji!,
            ),
        ],
      ),
    );
  }
}
