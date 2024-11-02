// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_story/providers/emoji_reaction_provider.dart';

class StoryReactionOverlay extends HookConsumerWidget {
  const StoryReactionOverlay({
    required this.textController,
    super.key,
  });

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
      (String emoji) {
        textController.clear();
        FocusScope.of(context).unfocus();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          emojiController.showReaction(emoji);
        });
      },
      [textController],
    );

    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final contentPadding = (screenHeight - keyboardHeight) * 0.25;

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Stack(
          children: [
            if (isKeyboardVisible)
              Positioned(
                bottom: keyboardHeight + contentPadding,
                left: 0,
                right: 0,
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
              ),
          ],
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
          child: Text(
            emoji,
            style: TextStyle(fontSize: 40.0.s),
          ),
        ),
      ),
    );
  }
}
