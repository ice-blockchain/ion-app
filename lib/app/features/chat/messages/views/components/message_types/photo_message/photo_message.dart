// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';
import 'package:ion/app/router/app_routes.dart';

class PhotoMessage extends HookWidget {
  const PhotoMessage({
    required this.isMe,
    required this.imageUrl,
    this.message,
    super.key,
  });

  final bool isMe;
  final String? message;
  final String imageUrl;

  static double get padding => 8.0.s;
  static double get maxWidth => MessageItemWrapper.maxWidth - padding * 2;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.all(padding),
      child: GestureDetector(
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
            _PhotoContent(imageUrl: imageUrl),
            SizedBox(height: 8.0.s),
            _MessageContent(
              message: message!,
              isMe: isMe,
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoContent extends StatelessWidget {
  const _PhotoContent({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: imageUrl,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0.s),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: PhotoMessage.maxWidth,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({
    required this.message,
    required this.isMe,
  });

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: PhotoMessage.maxWidth,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              message,
              style: context.theme.appTextThemes.body2.copyWith(
                color: isMe
                    ? context.theme.appColors.onPrimaryAccent
                    : context.theme.appColors.primaryText,
              ),
            ),
          ),
          MessageMetaData(isMe: isMe),
        ],
      ),
    );
  }
}
