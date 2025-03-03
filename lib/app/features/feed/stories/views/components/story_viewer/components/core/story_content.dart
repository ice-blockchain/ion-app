// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/can_reply_notifier.c.dart';
import 'package:ion/app/features/feed/stories/providers/emoji_reaction_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/components.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/header/header.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/services/uuid/uuid.dart';

class StoryContent extends HookConsumerWidget {
  const StoryContent({
    required this.post,
    super.key,
  });

  final ModifiablePostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiState = ref.watch(emojiReactionsControllerProvider);
    final textController = useTextEditingController();
    final isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    final canReply = ref.watch(canReplyProvider(post.toEventReference())).valueOrNull ?? false;
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);
    final isCurrentUserStory = currentPubkey == post.masterPubkey;

    useOnInit(
      () => ref.read(storyPauseControllerProvider.notifier).paused = isKeyboardVisible,
      [isKeyboardVisible],
    );

    final bottomPadding =
        isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom + 16.0.s : 16.0.s;

    final onSubmitted = useCallback(
      (String? content) async {
        if (content == null || content.isEmpty) return;

        final currentPubkey = ref.read(currentPubkeySelectorProvider);
        if (currentPubkey == null) {
          throw UserMasterPubkeyNotFoundException();
        }

        final conversationId =
            await ref.read(existChatConversationIdProvider(post.masterPubkey).future) ??
                generateUuid();
        final conversationMessageManagementService =
            await ref.read(sendE2eeMessageServiceProvider.future);

        await conversationMessageManagementService.sendMessage(
          conversationId: conversationId,
          content: content,
          participantsMasterPubkeys: [post.masterPubkey, currentPubkey],
        );

        textController.clear();
        if (context.mounted) {
          FocusScope.of(context).unfocus();
        }
      },
      [post.masterPubkey],
    );

    final isPaused = ref.watch(storyPauseControllerProvider);

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
          )
              .animate(target: isPaused ? 0 : 1)
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
                post: post,
                bottomPadding: bottomPadding,
              ),
              if (isKeyboardVisible)
                StoryReactionOverlay(
                  textController: textController,
                ),
            ],
          )
              .animate(target: isPaused ? 0 : 1)
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
