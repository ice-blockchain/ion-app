// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/video/views/components/video_actions.dart';
import 'package:ion/app/features/video/views/components/video_post_info.dart';
import 'package:ion/app/features/video/views/components/video_progress.dart';
import 'package:ion/app/features/video/views/components/video_slider.dart';
import 'package:ion/app/features/video/views/hooks/use_video_ended.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPage extends HookConsumerWidget {
  const VideoPage({
    required this.video,
    required this.eventReference,
    this.onVideoEnded,
    this.videoUrl,
    this.looping = false,
    super.key,
  });

  final ModifiablePostEntity video;
  final EventReference eventReference;
  final VoidCallback? onVideoEnded;
  final String? videoUrl;
  final bool looping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoPath = videoUrl ?? video.data.primaryVideo?.url;
    if (videoPath == null || videoPath.isEmpty) {
      return Text(context.i18n.video_not_found);
    }

    final playerController = ref.watch(
      videoControllerProvider(
        videoPath,
        autoPlay: true,
        looping: looping,
      ),
    );

    if (!playerController.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    useVideoEnded(
      playerController: playerController,
      onVideoEnded: onVideoEnded,
    );

    ref
      ..listen(appLifecycleProvider, (_, current) {
        if (!context.mounted) return;

        if (current == AppLifecycleState.resumed) {
          playerController.play();
        } else if (current == AppLifecycleState.inactive ||
            current == AppLifecycleState.paused ||
            current == AppLifecycleState.hidden) {
          playerController.pause();
        }
      })
      ..listen(globalMuteProvider, (_, isMuted) {
        if (playerController.value.isInitialized) {
          playerController.setVolume(isMuted ? 0 : 1);
        }
      });

    return VisibilityDetector(
      key: ValueKey(videoPath),
      onVisibilityChanged: (info) {
        if (!context.mounted) return;

        info.visibleFraction == 0 ? playerController.pause() : playerController.play();
      },
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: playerController.value.aspectRatio,
              child: CachedVideoPlayerPlus(playerController),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
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
                  eventReference: video.toEventReference(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
