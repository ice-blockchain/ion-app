// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

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

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);

    return MessageItemWrapper(
      isMe: isMe,
      messageEvent: eventMessage,
      contentPadding: EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: () {
          //TODO: Implement photo gallery
          // PhotoGalleryRoute(
          //   photoUrls: entity.data.visualMedias.map((e) => e).toList(),
          //   title: entity.data.content,
          //   senderName: 'Selena Marquez',
          //   sentAt: eventMessage.createdAt,
          // ).push<void>(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entity.data.visualMedias.length > 1)
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0.s,
                crossAxisSpacing: 4.0.s,
                children: List.generate(
                  entity.data.visualMedias.take(4).length,
                  (index) {
                    final isLastItem = index == entity.data.visualMedias.length - 1;
                    final isOddLength = entity.data.visualMedias.length.isOdd;

                    return StaggeredGridTile.count(
                      crossAxisCellCount: (isLastItem && isOddLength) ? 2 : 1,
                      mainAxisCellCount: 1,
                      child: _MediaContent(
                        media: entity.data.visualMedias[index],
                      ),
                    );
                  },
                ).reversed.toList(),
              )
            else
              _MediaContent(
                media: entity.data.visualMedias.first,
              ),
            SizedBox(height: 8.0.s),
            _MessageContent(
              eventMessage: eventMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaContent extends HookConsumerWidget {
  const _MediaContent({
    required this.media,
  });

  final MediaAttachment media;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originalImageOrThumbnail = useFuture(
      useMemoized(
        () async {
          final mediaType = MediaType.fromMimeType(media.mimeType);
          if (mediaType == MediaType.image) {
            return ref.read(mediaEncryptionServiceProvider).retrieveEncryptedMedia(media);
          } else {
            final thumbnail = media.thumb;

            if (thumbnail == null) {
              throw MediaThumbnailNotFoundException();
            }

            final mediaAttachment =
                MediaAttachment.fromJson(jsonDecode(thumbnail) as Map<String, dynamic>);
            final encryptedThumbnail = await ref
                .read(mediaEncryptionServiceProvider)
                .retrieveEncryptedMedia(mediaAttachment);

            return encryptedThumbnail;
          }
        },
        [media],
      ),
    );

    return _PhotoContent(
      mediaPath: originalImageOrThumbnail.data?.path,
      isThumbnail: media.thumb != null,
    );
  }
}

class _PhotoContent extends StatelessWidget {
  const _PhotoContent({
    required this.mediaPath,
    required this.isThumbnail,
  });

  final String? mediaPath;
  final bool isThumbnail;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: PhotoMessage.maxHeight,
        minHeight: PhotoMessage.maxHeight,
      ),
      child: mediaPath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12.0.s),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    File(mediaPath!),
                    fit: BoxFit.cover,
                    height: PhotoMessage.maxHeight,
                  ),
                  if (isThumbnail)
                    Align(
                      child: Container(
                        padding: EdgeInsets.all(6.0.s),
                        decoration: BoxDecoration(
                          color: context.theme.appColors.backgroundSheet.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12.0.s),
                        ),
                        child: Assets.svg.iconVideoPlay.icon(
                          size: 16.0.s,
                        ),
                      ),
                    ),
                ],
              ),
            )
          : const CenteredLoadingIndicator(),
    );
  }
}

class _MessageContent extends HookConsumerWidget {
  const _MessageContent({
    required this.eventMessage,
  });

  final EventMessage eventMessage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    final message = eventMessage.content;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
