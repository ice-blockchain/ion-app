// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'components/message_with_timestamp.dart';
part 'components/mute_button.dart';
part 'components/video_duration_label.dart';
part 'components/video_player_view.dart';

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
    final isMuted = useState(true);

    final videoController = ref.watch(
      videoControllerProvider(videoUrl, looping: true),
    );

    useEffect(
      () {
        videoController.setVolume(0); // Start muted
        return videoController.dispose;
      },
      [videoController],
    );

    return MessageItemWrapper(
      isMe: isMe,
      contentPadding: EdgeInsets.all(padding),
      child: VisibilityDetector(
        key: ValueKey(videoUrl),
        onVisibilityChanged: (info) {
          if (info.visibleFraction == 0) {
            videoController
              ..pause()
              ..setVolume(0);
            isMuted.value = true;
          } else {
            videoController.play();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VideoPlayerView(
              controller: videoController,
              isMuted: isMuted.value,
              onMuteToggle: () {
                isMuted.value = !isMuted.value;
                videoController.setVolume(isMuted.value ? 0 : 1);
              },
            ),
            SizedBox(height: 8.0.s),
            _MessageWithTimestamp(
              message: message ?? '',
              isMe: isMe,
            ),
          ],
        ),
      ),
    );
  }
}
