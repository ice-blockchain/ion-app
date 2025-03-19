// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:blurhash_ffi/blurhashffi_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
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
    final mediaAttachment = PrivateDirectMessageData.fromEventMessage(eventMessage)
        .media[messageMediaTableData.remoteUrl];

    useEffect(
      () {
        getApplicationDocumentsDirectory().then((value) {
          if (messageMediaTableData.localPath != null) {
            final path = '${value.path}/${messageMediaTableData.localPath!}';
            final isExist = File(path).existsSync();
            if (isExist) {
              localFile.value = File(path);
              return;
            }
          }

          if (mediaAttachment == null) {
            return;
          }

          ref
              .read(mediaEncryptionServiceProvider)
              .retrieveEncryptedMedia(mediaAttachment)
              .then((encryptedMedia) {
            localFile.value = encryptedMedia;
          });
        });
        return null;
      },
      [messageMediaTableData.remoteUrl, messageMediaTableData.localPath],
    );

    if (localFile.value == null && mediaAttachment?.blurhash == null) {
      return const SizedBox.shrink();
    }

    return Stack(
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
          const Center(
            child: IONLoadingIndicator(),
          ),
      ],
    );
  }
}
