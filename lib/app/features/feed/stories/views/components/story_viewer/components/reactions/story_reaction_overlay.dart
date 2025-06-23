// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/stories/providers/emoji_reaction_provider.c.dart';
import 'package:ion/app/features/feed/stories/providers/story_reply_provider.c.dart';

class StoryReactionOverlay extends HookConsumerWidget {
  const StoryReactionOverlay({
    required this.story,
    required this.textController,
    super.key,
  });

  final ModifiablePostEntity story;
  final TextEditingController textController;

  static const List<String> emojis = [
    '👍',
    '😊',
    '😍',
    '😂',
    '🔥',
    '😱',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiController = ref.read(emojiReactionsControllerProvider.notifier);

    final handleEmojiSelected = useCallback(
      (String emoji) async {
        textController.clear();
        FocusScope.of(context).unfocus();

        unawaited(
          ref.read(storyReplyProvider.notifier).sendReply(
                story,
                replyEmoji: emoji,
              ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          emojiController.showReaction(emoji);
        });
      },
      [textController],
    );

    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final contentPadding = (screenHeight - keyboardHeight) * 0.45.s;

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isKeyboardVisible) return const SizedBox.shrink();

        return PositionedDirectional(
          bottom: contentPadding,
          start: 0,
          end: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _EmojiRow(
                emojis: emojis.sublist(0, 3),
                onEmojiSelected: handleEmojiSelected,
              ),
              SizedBox(height: 40.0.s),
              _EmojiRow(
                emojis: emojis.sublist(3, 6),
                onEmojiSelected: handleEmojiSelected,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmojiRow extends StatelessWidget {
  const _EmojiRow({
    required this.emojis,
    required this.onEmojiSelected,
  });

  final List<String> emojis;
  final ValueChanged<String> onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: emojis.map((emoji) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.s),
          child: _ReactionButton(
            emoji: emoji,
            onTap: () => onEmojiSelected(emoji),
          ),
        );
      }).toList(),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.emoji,
    required this.onTap,
  });

  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 54.0.s,
        height: 54.0.s,
        child: Center(
          child: Text(emoji, style: TextStyle(fontSize: 40.0.s).platformEmojiAware()),
        ),
      ),
    );
  }
}
