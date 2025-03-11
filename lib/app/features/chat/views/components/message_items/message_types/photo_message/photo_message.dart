// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';

class PhotoMessage extends HookConsumerWidget {
  const PhotoMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  static double get padding => 8.0.s;

  static double get maxHeight => 300.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final photoUrl = useState<String?>(null);

    /// Key to get the width of the content container
    final contentContainerKey = useRef<GlobalKey>(GlobalKey());

    /// Width of the image
    final imageWidth = useState<double>(0);

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);

    final reactionsStream =
        ref.watch(conversationMessageReactionDaoProvider).messageReactions(eventMessage);

    final reactions = useStream(reactionsStream);

    useEffect(
      () {
        ref.read(mediaEncryptionServiceProvider).retrieveEncryptedMedia(
          [entity.data.primaryPhoto!],
        ).then((value) {
          if (context.mounted) photoUrl.value = value.first.path;
        });
        return null;
      },
      [entity],
    );

    if (photoUrl.value == null) {
      return const SizedBox.shrink();
    }

    return MessageItemWrapper(
      isMe: isMe,
      messageEvent: eventMessage,
      contentPadding: EdgeInsets.all(padding),
      child: LayoutBuilder(
        builder: (context, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            /// Update the minimum width of the image based on the content container width

            if (eventMessage.content.isEmpty && reactions.data == null || reactions.data!.isEmpty) {
              imageWidth.value = double.infinity;
            } else {
              imageWidth.value = contentContainerKey.value.currentContext?.size?.width ?? 0;
            }
          });
          return GestureDetector(
            onTap: () {
              PhotoGalleryRoute(
                photoUrls: [photoUrl.value!],
                title: entity.data.content,
                senderName: 'Selena Marquez',
                sentAt: DateTime.now(),
              ).push<void>(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PhotoContent(
                  imageUrl: photoUrl.value!,
                  width: imageWidth.value,
                ),
                SizedBox(height: 8.0.s),
                _MessageContent(
                  isMe: isMe,
                  reactions: reactions.data,
                  message: eventMessage.content,
                  eventMessage: eventMessage,
                  key: contentContainerKey.value,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PhotoContent extends StatelessWidget {
  const _PhotoContent({
    required this.imageUrl,
    required this.width,
  });

  final String imageUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: PhotoMessage.maxHeight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0.s),
        child: Image.file(
          File(imageUrl),
          fit: BoxFit.fitWidth,
          width: width,
        ),
      ),
    );
  }
}

class _MessageContent extends HookConsumerWidget {
  const _MessageContent({
    required this.isMe,
    required this.reactions,
    required this.message,
    required this.eventMessage,
    super.key,
  });

  final bool isMe;
  final List<MessageReactionGroup>? reactions;
  final String message;
  final EventMessage eventMessage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: message.isEmpty && (reactions == null || reactions!.isEmpty)
              ? FlexFit.tight
              : FlexFit.loose,
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
              MessageReactions(
                isMe: isMe,
                eventMessage: eventMessage,
              ),
            ],
          ),
        ),
        MessageMetaData(eventMessage: eventMessage),
      ],
    );
  }
}
