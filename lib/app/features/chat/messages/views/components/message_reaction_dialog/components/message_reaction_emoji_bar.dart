// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/recent_emoji_reactions_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageReactionEmojiBar extends ConsumerWidget {
  const MessageReactionEmojiBar({
    required this.isMe,
    super.key,
  });
  static double get height => 72.0.s;

  final bool isMe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentEmojiReactions = ref.watch(recentEmojiReactionsProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: 6.0.s),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.theme.appColors.onPrimaryAccent,
                borderRadius: BorderRadius.circular(16.0.s),
              ),
              padding: EdgeInsets.all(12.0.s),
              child: Row(
                children: [
                  Row(
                    children: recentEmojiReactions.map(
                      (emoji) {
                        return _EmojiButton(emoji: emoji);
                      },
                    ).toList(),
                  ),
                  const _ShowMoreEmojiButton(),
                ],
              ),
            ),
            const _EmojiBarNotch(),
          ],
        ),
      ),
    );
  }
}

class _EmojiBarNotch extends StatelessWidget {
  const _EmojiBarNotch();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.s),
      child: Assets.svg.iconBubleCorner.iconWithDimensions(width: 20.0.s, height: 14.0.s),
    );
  }
}

class _ShowMoreEmojiButton extends StatelessWidget {
  const _ShowMoreEmojiButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SearchEmojiRoute().push<void>(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0.s, horizontal: 9.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.primaryBackground,
          borderRadius: BorderRadius.circular(20.0.s),
        ),
        child: Assets.svg.iconPostAddanswer.icon(
          size: 20.0.s,
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    );
  }
}

class _EmojiButton extends ConsumerWidget {
  const _EmojiButton({
    required this.emoji,
  });

  final String emoji;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(recentEmojiReactionsProvider.notifier).addEmoji(emoji);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.0.s, horizontal: 10.0.s),
        margin: EdgeInsets.only(right: 14.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.primaryBackground,
          borderRadius: BorderRadius.circular(20.0.s),
        ),
        child: Text(
          emoji,
          style: context.theme.appTextThemes.title.copyWith(height: 1),
        ),
      ),
    );
  }
}
