// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/emoji_reaction_provider.c.dart';

class StoryReactionNotification extends ConsumerWidget {
  const StoryReactionNotification({
    required this.emoji,
    super.key,
  });

  final String emoji;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emojiState = ref.watch(emojiReactionsControllerProvider);

    final appTextThemes = context.theme.appTextThemes;
    final notificationColor = context.theme.appColors.onPrimaryAccent;
    final i18n = context.i18n;

    return Positioned(
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
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0.s),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.s,
                  vertical: 8.0.s,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16.0.s),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      i18n.reaction_was_sent,
                      style: appTextThemes.body2.copyWith(color: notificationColor),
                    ),
                    Text(
                      ' $emoji',
                      style: TextStyle(
                        fontSize: 16.0.s,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
