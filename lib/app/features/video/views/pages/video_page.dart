// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/video/views/components/video_actions.dart';
import 'package:ion/app/features/video/views/components/video_controls.dart';
import 'package:ion/app/features/video/views/components/video_header.dart';
import 'package:ion/app/features/video/views/components/video_post_info.dart';
import 'package:ion/app/features/video/views/components/video_progress.dart';
import 'package:ion/app/features/video/views/components/video_slider.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends HookConsumerWidget {
  const VideoPage({
    required this.video,
    this.onVideoEnded,
    super.key,
  });

  final PostEntity video;
  final VoidCallback? onVideoEnded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoPath = video.data.primaryMedia?.url;
    if (videoPath == null || videoPath.isEmpty) {
      return Text(context.i18n.video_not_found);
    }
    final playerController = ref.watch(
      videoControllerProvider(
        videoPath,
        autoPlay: true,
      ),
    );

    if (!playerController.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    final hasVideoEnded = useState(false);

    useEffect(
      () {
        void listener() {
          final duration = playerController.value.duration;
          final position = playerController.value.position;

          final isVideoEnded = position >= duration - const Duration(milliseconds: 500);
          if (isVideoEnded && !hasVideoEnded.value) {
            hasVideoEnded.value = true;
            onVideoEnded?.call();
          } else if (!isVideoEnded && hasVideoEnded.value) {
            hasVideoEnded.value = false;
          }
        }

        playerController.addListener(listener);
        return () => playerController.removeListener(listener);
      },
      [playerController],
    );

    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: playerController.value.aspectRatio,
            child: VideoPlayer(playerController),
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VideoHeader(),
              const Spacer(),
              VideoControls(videoPath: videoPath),
              VideoPostInfo(videoPost: video),
              VideoProgress(
                controller: playerController,
                builder: (context, position, duration) => VideoSlider(
                  position: position,
                  duration: duration,
                  onChangeStart: (_) => playerController.pause(),
                  onChangeEnd: (_) => playerController.play(),
                  onChanged: (value) {
                    if (playerController.value.isInitialized) {
                      playerController.seekTo(
                        Duration(milliseconds: value.toInt()),
                      );
                    }
                  },
                ),
              ),
              VideoActions(
                eventReference: EventReference.fromNostrEntity(video),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
