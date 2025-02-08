// SPDX-License-Identifier: ice License 1.0

part of '../video_message.dart';

class _MessageWithTimestamp extends StatelessWidget {
  const _MessageWithTimestamp({
    required this.message,
    required this.isMe,
    required this.createdAt,
    this.reactions,
  });

  final String message;
  final bool isMe;
  final DateTime createdAt;
  final List<MessageReactionGroup>? reactions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0.s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: isMe
                          ? context.theme.appColors.onPrimaryAccent
                          : context.theme.appColors.primaryText,
                    ),
                  ),
                MessageReactions(reactions: reactions),
              ],
            ),
          ),
          MessageMetaData(isMe: isMe, createdAt: createdAt),
        ],
      ),
    );
  }
}
