// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/video_preview/video_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/messages/views/components/message_author/message_author.dart';
import 'package:ion/app/features/chat/messages/views/components/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/model/message_author.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.dart';

part 'components/message_with_timestamp.dart';

class VideoMessage extends HookConsumerWidget {
  const VideoMessage({
    required this.isMe,
    required this.videoUrl,
    this.isLastMessageFromSender = true,
    this.author,
    this.message,
    this.reactions,
    super.key,
  });

  final bool isMe;
  final String? message;
  final String videoUrl;
  final bool isLastMessageFromSender;
  final MessageAuthor? author;
  final List<MessageReactionGroup>? reactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxContentWidth = 272.0.s;
    final maxVideoHeight = 340.0.s;

    useAutomaticKeepAlive();

    final contentWidth = useState<double>(maxContentWidth);
    final videoController = ref.watch(videoControllerProvider(videoUrl, looping: true));

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
      isLastMessageFromSender: isLastMessageFromSender,
      contentPadding: EdgeInsets.all(padding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            /// Update the minimum width of the image based on the content container width
            if (message == null && reactions == null) {
              videoWidth.value = double.infinity;
            } else {
              videoWidth.value = containerKey.value.currentContext?.size?.width ?? 0;
            }
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessageAuthorNameWidget(author: author),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.0.s, maxWidth: videoWidth.value),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0.s),
                  child: VideoPreview(videoUrl: videoUrl),
      contentPadding: EdgeInsets.all(8.0.s),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: contentWidth.value,
        ),
        child: Column(
          children: [
            MessageAuthorNameWidget(author: author),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxVideoHeight,
                maxWidth: maxContentWidth,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0.s),
                child: VideoPreview(
                  controller: videoController,
                ),
              ),
            ),
            _MessageWithTimestamp(
              isMe: isMe,
              message: message ?? '',
              reactions: reactions,
            ),
          ],
        ),
      ),
    );
  }
}
