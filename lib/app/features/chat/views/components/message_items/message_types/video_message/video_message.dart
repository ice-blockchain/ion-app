// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/video_preview/video_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';

part 'components/message_with_timestamp.dart';

class VideoMessage extends HookConsumerWidget {
  const VideoMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoUrl = useState<String?>(null);

    final maxContentWidth = 272.0.s;
    final maxVideoHeight = 340.0.s;

    useAutomaticKeepAlive();

    final contentWidth = useState<double>(maxContentWidth);

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);

    final videoAttachmentUrl = entity.data.primaryVideo?.url;

    print('videoAttachmentUrl: $videoAttachmentUrl');

    useEffect(
      () {
        ref.read(mediaEncryptionServiceProvider).retreiveEncryptedMedia(
          [entity.data.primaryVideo!],
        ).then((value) {
          videoUrl.value = value.first.path;
        });
        return null;
      },
      [videoAttachmentUrl],
    );

    if (videoUrl.value == null) {
      return const SizedBox.shrink();
    }

    final videoController = ref.watch(videoControllerProvider(videoUrl.value!));

    // Identify acceptable video width to limit message content width
    if (videoController.value.isInitialized) {
      final aspectRatio = videoController.value.aspectRatio;

      var adjustedWidth = maxContentWidth;
      var adjustedHeight = adjustedWidth / aspectRatio;

      if (adjustedHeight > maxVideoHeight) {
        adjustedHeight = maxVideoHeight;
        adjustedWidth = adjustedHeight * aspectRatio;
      }

      contentWidth.value = adjustedWidth;
    }

    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.all(8.0.s),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: contentWidth.value,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxVideoHeight,
                maxWidth: maxContentWidth,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0.s),
                child: VideoPreview(
                  videoUrl: videoUrl.value!,
                  videoController: videoController,
                ),
              ),
            ),
            _MessageWithTimestamp(eventMessage: eventMessage),
          ],
        ),
      ),
    );
  }
}
