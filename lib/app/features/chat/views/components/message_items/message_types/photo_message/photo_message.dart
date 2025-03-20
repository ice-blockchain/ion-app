// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
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

    final isMe = useMemoized(
      () => ref.read(isCurrentUserSelectorProvider(eventMessage.masterPubkey)),
      [eventMessage.masterPubkey],
    );

    final messageMediasStream = useMemoized(
      () => ref.read(messageMediaDaoProvider).watchByEventId(eventMessage.id),
      [eventMessage.id],
    );

    final messageMedias = useStream(messageMediasStream);

    if (messageMedias.data?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

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
            if (messageMedias.data!.length > 1)
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0.s,
                crossAxisSpacing: 4.0.s,
                children: List.generate(
                  messageMedias.data!.length,
                  (index) {
                    final isLastItem = index == messageMedias.data!.length - 1;
                    final isOddLength = messageMedias.data!.length.isOdd;

                    return StaggeredGridTile.count(
                      crossAxisCellCount: (isLastItem && isOddLength) ? 2 : 1,
                      mainAxisCellCount: 1,
                      child: MediaContent(
                        media: messageMedias.data![index],
                        eventMessage: eventMessage,
                      ),
                    );
                  },
                ).reversed.toList(),
              )
            else
              MediaContent(
                media: messageMedias.data!.first,
                eventMessage: eventMessage,
              ),
          ],
        ),
      ),
    );
  }
}

class MediaContent extends HookConsumerWidget {
  const MediaContent({
    required this.media,
    required this.eventMessage,
    super.key,
  });

  final MessageMediaTableData media;
  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileCurrent = useState<File?>(null);
    final file = fileCurrent.value;

    final entity = PrivateDirectMessageData.fromEventMessage(eventMessage);
    final mediaAttachment = entity.visualMedias.where((e) => e.url == media.remoteUrl).firstOrNull;

    final blurhashCurrent = mediaAttachment?.blurhash;

    final dimensionsCurrent = useMemoized(
      () {
        if (mediaAttachment == null) {
          return null;
        }

        try {
          final dimensions = mediaAttachment.dimension.split('x').map(int.parse).toList();
          return Size(dimensions.first.toDouble(), dimensions.last.toDouble());
        } catch (e) {
          return Size(PhotoMessage.maxHeight, PhotoMessage.maxHeight);
        }
      },
      [mediaAttachment?.dimension],
    );

    useEffect(
      () {
        if (mediaAttachment == null) {
          return;
        }

        if (fileCurrent.value != null) {
          return;
        }

        if (mediaAttachment.url.isEmpty) {
          return;
        }

        final mediaType = MediaType.fromMimeType(mediaAttachment.mimeType);
        if (mediaType == MediaType.image) {
          ref
              .read(mediaEncryptionServiceProvider)
              .retrieveEncryptedMedia(mediaAttachment)
              .then((encryptedMedia) {
            fileCurrent.value = encryptedMedia;
          });
        } else {
          //todo: handle video
        }
        return null;
      },
      [
        media.remoteUrl,
        eventMessage.id,
        fileCurrent.value,
        blurhashCurrent,
        dimensionsCurrent,
      ],
    );

    return Stack(
      children: [
        Stack(
          children: <Widget>[
            if (media.status == MessageMediaStatus.processing)
              const Positioned.fill(
                child: Center(
                  child: IONLoadingIndicator(),
                ),
              ),
            Column(
              children: <Widget>[
                _PhotoContent(
                  file: file,
                  blurhash: blurhashCurrent,
                  dimensions: dimensionsCurrent,
                  eventMessage: eventMessage,
                ),
                SizedBox(height: 8.0.s),
                _MessageContent(eventMessage: eventMessage),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _PhotoContent extends HookConsumerWidget {
  const _PhotoContent({
    required this.file,
    required this.blurhash,
    required this.dimensions,
    required this.eventMessage,
  });

  final File? file;
  final String? blurhash;
  final Size? dimensions;
  final EventMessage eventMessage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: PhotoMessage.maxHeight,
        minHeight: PhotoMessage.maxHeight,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (blurhash != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0.s),
              child: BlurhashFfi(
                decodingWidth: dimensions?.width.toInt() ?? PhotoMessage.maxHeight.toInt(),
                decodingHeight: dimensions?.height.toInt() ?? PhotoMessage.maxHeight.toInt(),
                hash: blurhash!,
                color: isMe
                    ? context.theme.appColors.primaryAccent
                    : context.theme.appColors.onPrimaryAccent,
              ),
            ),
          if (file != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0.s),
              child: Image.file(
                file!,
                fit: BoxFit.cover,
                height: PhotoMessage.maxHeight,
              ),
            ),
          // if (false)
          //   Align(
          //     child: Container(
          //       padding: EdgeInsets.all(6.0.s),
          //       decoration: BoxDecoration(
          //         color: context.theme.appColors.backgroundSheet.withValues(alpha: 0.7),
          //         borderRadius: BorderRadius.circular(12.0.s),
          //       ),
          //       child: Assets.svg.iconVideoPlay.icon(
          //         size: 16.0.s,
          //       ),
          //     ),
          //   ),
        ],
      ),
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
