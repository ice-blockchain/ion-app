// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper.dart';

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

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();
    return MessageItemWrapper(
      contentPadding: EdgeInsets.all(
        padding,
      ),
      isMe: isMe,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0.s),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MessageItemWrapper.maxWidth - padding * 2,
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MessageItemWrapper.maxWidth - padding * 2,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 8.0.s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      message ?? '',
                      style: context.theme.appTextThemes.body2.copyWith(
                        color: isMe
                            ? context.theme.appColors.onPrimaryAccent
                            : context.theme.appColors.primaryText,
                      ),
                    ),
                  ),
                  MessageTimeStamp(isMe: isMe),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
