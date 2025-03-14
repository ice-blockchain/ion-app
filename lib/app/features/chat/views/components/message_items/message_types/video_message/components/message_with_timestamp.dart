// SPDX-License-Identifier: ice License 1.0

part of '../video_message.dart';

class _MessageWithTimestamp extends HookConsumerWidget {
  const _MessageWithTimestamp({
    required this.eventMessage,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final message = eventMessage.content;

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
                if (message != null && message.isNotEmpty)
                  Text(
                    message,
                    style: context.theme.appTextThemes.body2.copyWith(
                      color: isMe
                          ? context.theme.appColors.onPrimaryAccent
                          : context.theme.appColors.primaryText,
                    ),
                  ),
                //TODO: Add reactions
                // MessageReactions(reactions: reactions),
                //TODO: add metadata
                //MessageReactions(reactions: reactions),
              ],
            ),
          ),
          MessageMetaData(eventMessage: eventMessage),
        ],
      ),
    );
  }
}
