// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/video_preview_wrapper/video_preview_wrapper.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';

part 'components/message_with_timestamp.dart';

class VideoMessage extends HookConsumerWidget {
  const VideoMessage({
    required this.isMe,
    required this.videoUrl,
    this.message,
    super.key,
  });
  final bool isMe;
  final String? message;
  final String videoUrl;

  static double get padding => 8.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final videoController = ref.watch(
      videoControllerProvider(videoUrl, looping: true),
    );

    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0.s),
            child: VideoPreviewWrapper(controller: videoController),
          ),
          SizedBox(height: 8.0.s),
          _MessageWithTimestamp(
            message: message ?? '',
            isMe: isMe,
          ),
        ],
      ),
    );
  }
}
