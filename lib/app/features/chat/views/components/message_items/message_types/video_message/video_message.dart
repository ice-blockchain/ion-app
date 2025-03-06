// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/video_preview/video_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
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
    useAutomaticKeepAlive();

    final maxContentWidth = 272.0.s;
    final maxVideoHeight = 340.0.s;

    final videoUrl = useState<String?>(null);
    final contentWidth = useState<double>(maxContentWidth);

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    useEffect(
      () {
        if (eventMessage.kind == PrivateDirectMessageEntity.kind) {
          final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);
          ref.read(mediaEncryptionServiceProvider).retrieveEncryptedMedia(
            [entity.data.primaryVideo!],
          ).then((value) {
            if (context.mounted) videoUrl.value = value.first.path;
          });
        }
        return null;
      },
      [eventMessage],
    );

    final videoController = videoUrl.value == null
        ? null
        : ref.watch(videoControllerProvider(videoUrl.value!, looping: true));

    // Identify acceptable video width to limit message content width
    if (videoController?.value.isInitialized ?? false) {
      final aspectRatio = videoController!.value.aspectRatio;

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
      messageEvent: eventMessage,
      contentPadding: EdgeInsets.all(8.0.s),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
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
                child: videoUrl.value == null
                    //TODO: use thumbnail
                    ? const Center(
                        child: IONLoadingIndicator(),
                      )
                    : VideoPreview(
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
