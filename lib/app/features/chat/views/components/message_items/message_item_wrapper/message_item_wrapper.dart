// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/chat_medias_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reaction_dialog/message_reaction_dialog.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageItemWrapper extends HookConsumerWidget {
  const MessageItemWrapper({
    required this.isMe,
    required this.child,
    required this.messageItem,
    required this.contentPadding,
    this.isLastMessageFromAuthor = true,
    super.key,
  });

  final bool isMe;
  final Widget child;
  final bool isLastMessageFromAuthor;
  final ChatMessageInfoItem messageItem;
  final EdgeInsetsGeometry contentPadding;

  /// The maximum width of the message content in the chat
  static double get maxWidth => 282.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageItemKey = useMemoized(GlobalKey.new);

    // final repliedEventMessage = ref.watch(repliedMessageListItemProvider(messageItem));

    // final repliedMessageItem = getRepliedMessageListItem(
    //   ref: ref,
    //   repliedEventMessage: repliedEventMessage.valueOrNull,
    // );

    final deliveryStatus =
        ref.watch(conversationMessageDataDaoProvider).messageStatus(messageItem.eventMessage.id);

    final showReactDialog = useCallback(
      () async {
        try {
          var messageStatus = MessageDeliveryStatus.created;

          final subscription = deliveryStatus.listen((status) {
            messageStatus = status;
          });

          final emoji = await showDialog<String>(
            context: context,
            barrierColor: Colors.transparent,
            useSafeArea: false,
            builder: (context) => MessageReactionDialog(
              isMe: isMe,
              messageItem: messageItem,
              messageStatus: messageStatus,
              renderObject: messageItemKey.currentContext!.findRenderObject()!,
            ),
          );

          if (emoji != null) {
            final e2eeMessageService = await ref.read(sendE2eeMessageServiceProvider.future);
            await e2eeMessageService.sendReaction(
              content: emoji,
              kind14Rumor: messageItem.eventMessage,
            );
          }

          await subscription.cancel();
        } catch (e, st) {
          Logger.log('Error showing message reaction dialog:', error: e, stackTrace: st);
        }
      },
      [messageItemKey, isMe, messageItem],
    );

    return StreamBuilder<MessageDeliveryStatus>(
      stream: deliveryStatus,
      initialData: MessageDeliveryStatus.deleted,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == MessageDeliveryStatus.deleted) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: isMe ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
          child: GestureDetector(
            onLongPress: () {
              HapticFeedback.mediumImpact();
              showReactDialog();
            },
            child: RepaintBoundary(
              key: messageItemKey,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: contentPadding,
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? context.theme.appColors.primaryAccent
                          : context.theme.appColors.onPrimaryAccent,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(12.0.s),
                        topEnd: Radius.circular(12.0.s),
                        bottomStart: !isLastMessageFromAuthor || isMe
                            ? Radius.circular(12.0.s)
                            : Radius.zero,
                        bottomEnd:
                            isMe && isLastMessageFromAuthor ? Radius.zero : Radius.circular(12.0.s),
                      ),
                    ),
                    child: child,
                  ),
                  if (snapshot.hasData && snapshot.data == MessageDeliveryStatus.failed)
                    Row(
                      children: [
                        SizedBox(width: 6.0.s),
                        Assets.svg.iconMessageFailed.icon(
                          color: context.theme.appColors.attentionRed,
                          size: 16.0.s,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ChatMessageInfoItem? getRepliedMessageListItem({
    required WidgetRef ref,
    required EventMessage? repliedEventMessage,
  }) {
    if (repliedEventMessage == null) {
      return null;
    }

    final repliedEntity = PrivateDirectMessageEntity.fromEventMessage(repliedEventMessage);

    if (repliedEntity.data.messageType == MessageType.profile) {
      final profilePubkey = EventReference.fromEncoded(repliedEntity.data.content).pubkey;

      final userMetadata = ref.watch(userMetadataProvider(profilePubkey)).valueOrNull;
      return ShareProfileItem(
        eventMessage: repliedEventMessage,
        contentDescription: userMetadata?.data.name ?? repliedEntity.data.content,
      );
    } else if (repliedEntity.data.messageType == MessageType.visualMedia) {
      final messageMedias =
          ref.watch(chatMediasProvider(eventMessageId: repliedEventMessage.id)).valueOrNull ?? [];

      return MediaItem(
        medias: messageMedias,
        eventMessage: repliedEventMessage,
        contentDescription: ref.context.i18n.common_media,
      );
    }

    return switch (repliedEntity.data.messageType) {
      MessageType.profile => null,
      MessageType.storyReply => null,
      MessageType.visualMedia => null,
      // TODO: implement replied funds request message item
      MessageType.requestFunds => null,
      MessageType.text => TextItem(
          eventMessage: repliedEventMessage,
          contentDescription: repliedEntity.data.content,
        ),
      MessageType.emoji => EmojiItem(
          eventMessage: repliedEventMessage,
          contentDescription: repliedEntity.data.content,
        ),
      MessageType.audio => AudioItem(
          eventMessage: repliedEventMessage,
          contentDescription: ref.context.i18n.common_voice_message,
        ),
      MessageType.document => DocumentItem(
          eventMessage: repliedEventMessage,
          contentDescription: repliedEntity.data.content,
        ),
    };
  }
}
