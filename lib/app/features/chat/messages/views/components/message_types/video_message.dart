// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/mesage_timestamp.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
    final videoKey = useRef(GlobalKey());
    final isMuted = useState(true);

    final videoController = ref.watch(
      videoControllerProvider(videoUrl, looping: true),
    );

    useEffect(
      () {
        videoController.setVolume(0);
        return videoController.dispose;
      },
      [],
    );

    return MessageItemWrapper(
      contentPadding: EdgeInsets.all(
        padding,
      ),
      isMe: isMe,
      child: VisibilityDetector(
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
        key: ValueKey(videoUrl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0.s),
              child: Stack(
                children: [
                  AspectRatio(
                    key: videoKey.value,
                    aspectRatio: videoController.value.aspectRatio,
                    child: VideoPlayer(videoController),
                  ),
                  Positioned(
                    bottom: 5.0.s,
                    left: 5.0.s,
                    right: 5.0.s,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(4.0.s, 0, 4.0.s, 1.0.s),
                          decoration: BoxDecoration(
                            color: context.theme.appColors.backgroundSheet.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6.0.s),
                          ),
                          child: Text(
                            formatDuration(videoController.value.duration),
                            style: context.theme.appTextThemes.caption.copyWith(
                              color: context.theme.appColors.secondaryBackground,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            isMuted.value = !isMuted.value;
                            videoController.setVolume(isMuted.value ? 0 : 1);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6.0.s),
                            decoration: BoxDecoration(
                              color: context.theme.appColors.backgroundSheet.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12.0.s),
                            ),
                            child: !isMuted.value
                                ? Assets.svg.iconChannelUnmute.icon(
                                    size: 16.0.s,
                                    color: context.theme.appColors.onPrimaryAccent,
                                  )
                                : Assets.svg.iconChannelMute.icon(
                                    size: 16.0.s,
                                    color: context.theme.appColors.onPrimaryAccent,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0.s),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      message ?? '',
                      style: context.theme.appTextThemes.body2.copyWith(
                        color: isMe
                            ? context.theme.appColors.onPrimaryAccent
                            : context.theme.appColors.primaryText,
                      ),
                    ),
                  ),
                  MessageTimeStamp(isMe: isMe),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
