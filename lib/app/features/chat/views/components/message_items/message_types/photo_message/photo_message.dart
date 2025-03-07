// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_author/message_author.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/router/app_routes.c.dart';

class PhotoMessage extends HookWidget {
  const PhotoMessage({
    required this.isMe,
    required this.imageUrl,
    required this.createdAt,
    required this.eventMessage,
    this.isLastMessageFromAuthor = true,
    this.message,
    this.reactions,
    this.author,
    super.key,
  });

  final bool isMe;

  final String? message;
  final String imageUrl;
  final DateTime createdAt;
  final MessageAuthor? author;
  final EventMessage eventMessage;
  final bool isLastMessageFromAuthor;
  final List<MessageReactionGroup>? reactions;

  static double get padding => 8.0.s;

  static double get maxHeight => 300.0.s;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    /// Key to get the width of the content container
    final contentContainerKey = useRef<GlobalKey>(GlobalKey());

    /// Width of the image
    final imageWidth = useState<double>(0);

    return MessageItemWrapper(
      isMe: isMe,
      messageEvent: eventMessage,
      isLastMessageFromAuthor: isLastMessageFromAuthor,
      contentPadding: EdgeInsets.all(padding),
      child: LayoutBuilder(
        builder: (context, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            /// Update the minimum width of the image based on the content container width
            if (message == null && reactions == null) {
              imageWidth.value = double.infinity;
            } else {
              imageWidth.value = contentContainerKey.value.currentContext?.size?.width ?? 0;
            }
          });
          return GestureDetector(
            onTap: () {
              PhotoGalleryRoute(
                photoUrls: [imageUrl],
                title: message ?? '',
                senderName: 'Selena Marquez',
                sentAt: DateTime.now(),
              ).push<void>(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MessageAuthorNameWidget(author: author),
                _PhotoContent(
                  imageUrl: imageUrl,
                  width: imageWidth.value,
                ),
                SizedBox(height: 8.0.s),
                _MessageContent(
                  createdAt: createdAt,
                  key: contentContainerKey.value,
                  message: message,
                  isMe: isMe,
                  reactions: reactions,
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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.fitWidth,
          width: width,
        ),
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({
    required this.isMe,
    required this.createdAt,
    this.message,
    this.reactions,
    super.key,
  });

  final String? message;
  final bool isMe;
  final DateTime createdAt;
  final List<MessageReactionGroup>? reactions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          fit: (message == null && reactions == null) ? FlexFit.tight : FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message != null)
                Text(
                  message!,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: isMe
                        ? context.theme.appColors.onPrimaryAccent
                        : context.theme.appColors.primaryText,
                  ),
                ),
              //TODO: add metadata
              //MessageReactions(reactions: reactions),
            ],
          ),
        ),
        //TODO: add metadata
        // MessageMetaData(isMe: isMe, createdAt: createdAt),
      ],
    );
  }
}
