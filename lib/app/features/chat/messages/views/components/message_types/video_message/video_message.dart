// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/video_preview/video_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/messages/views/components/message_reactions/message_reactions.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';

part 'components/message_with_timestamp.dart';

class VideoMessage extends HookConsumerWidget {
  const VideoMessage({
    required this.isMe,
    required this.videoUrl,
    this.message,
    this.reactions,
    super.key,
  });
  final bool isMe;
  final String? message;
  final String videoUrl;
  final List<MessageReactionGroup>? reactions;
  static double get padding => 8.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final videoController = ref.watch(videoControllerProvider(videoUrl, looping: true));
    final containerKey = useRef<GlobalKey>(GlobalKey());
    final videoWidth = useState<double>(0);

    return MessageItemWrapper(
      isMe: isMe,
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
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.0.s, maxWidth: videoWidth.value),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0.s),
                  child: VideoPreview(controller: videoController),
                ),
              ),
              _MessageWithTimestamp(
                key: containerKey.value,
                message: message ?? '',
                isMe: isMe,
                reactions: reactions,
              ),
            ],
          );
        },
      ),
    );
  }
}
