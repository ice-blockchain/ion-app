// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_chat_media_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:path_provider/path_provider.dart';

class VisualMediaContent extends HookConsumerWidget {
  const VisualMediaContent({
    required this.messageMediaTableData,
    required this.eventMessage,
    required this.height,
    super.key,
  });

  final MessageMediaTableData messageMediaTableData;
  final EventMessage eventMessage;
  final double height;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localFile = useState<File?>(null);
    final entity = PrivateDirectMessageData.fromEventMessage(eventMessage);
    final mediaAttachment = entity.media[messageMediaTableData.remoteUrl];

    useEffect(
      () {
        getApplicationDocumentsDirectory().then((value) {
          if (messageMediaTableData.cacheKey != null) {
            final path = '${value.path}/${messageMediaTableData.cacheKey!}';
            final isExist = File(path).existsSync();
            if (isExist) {
              localFile.value = File(path);
              return;
            }
          }

          if (mediaAttachment == null) {
            return;
          }

          final thumb = entity.media.values.firstWhere((e) => e.url == mediaAttachment.thumb);

          ref
              .read(mediaEncryptionServiceProvider)
              .retrieveEncryptedMedia(thumb)
              .then((encryptedMedia) {
            localFile.value = encryptedMedia;
          });
        });
        return null;
      },
      [messageMediaTableData.remoteUrl, messageMediaTableData.cacheKey],
    );

    if (localFile.value == null && mediaAttachment?.blurhash == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      key: Key(messageMediaTableData.id.toString()),
      alignment: Alignment.center,
      children: [
        if (mediaAttachment?.blurhash != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0.s),
            child: SizedBox(
              // width: width,
              height: height,
              child: BlurhashFfi(
                hash: mediaAttachment!.blurhash!,
                // decodingHeight: height.toInt(),
                // decodingWidth: width.toInt(),
              ),
            ),
          ),
        if (localFile.value != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0.s),
            child: Image.file(
              localFile.value!,
              fit: BoxFit.cover,
              // width: width,
              width: double.infinity,
              height: height,
            ),
          ),
        if (messageMediaTableData.status == MessageMediaStatus.processing)
          CancelButton(
            messageMediaId: messageMediaTableData.id,
          ),
      ],
    );
  }
}

class CancelButton extends ConsumerWidget {
  const CancelButton({
    required this.messageMediaId,
    super.key,
  });

  final int messageMediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(sendChatMediaProvider(messageMediaId).notifier).cancel();
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.appColors.backgroundSheet.withValues(alpha: 0.7),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(2.0.s),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Assets.svg.iconSheetClose.icon(
              size: 16.0.s,
              color: context.theme.appColors.onPrimaryAccent,
            ),
            SizedBox(
              width: 26.0.s,
              height: 26.0.s,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: context.theme.appColors.onPrimaryAccent,
                // value: 0.5,
                strokeCap: StrokeCap.round,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
