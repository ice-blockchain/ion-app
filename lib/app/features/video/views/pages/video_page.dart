// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/video/views/components/video_actions.dart';
import 'package:ion/app/features/video/views/components/video_button.dart';
import 'package:ion/app/features/video/views/components/video_post_info.dart';
import 'package:ion/app/features/video/views/components/video_progress.dart';
import 'package:ion/app/features/video/views/components/video_slider.dart';
import 'package:ion/app/features/video/views/hooks/use_video_ended.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPage extends HookConsumerWidget {
  const VideoPage({
    required this.video,
    this.onVideoEnded,
    this.videoUrl,
    this.looping = false,
    this.framedEventReference,
    super.key,
  });

  final ModifiablePostEntity video;
  final VoidCallback? onVideoEnded;
  final String? videoUrl;
  final EventReference? framedEventReference;
  final bool looping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoPath = videoUrl ?? video.data.primaryVideo?.url;
    if (videoPath == null || videoPath.isEmpty) {
      return Text(context.i18n.video_not_found);
    }

    final playerController = ref.watch(
      videoControllerProvider(
        VideoControllerParams(
          sourcePath: videoPath,
          autoPlay: true,
          looping: looping,
          uniqueId: framedEventReference?.encode() ?? '',
        ),
      ),
    );

    if (!playerController.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    final isPlaying = useState(playerController.value.isPlaying);

    useEffect(
      () {
        void listener() {
          isPlaying.value = playerController.value.isPlaying;
        }

        playerController.addListener(listener);
        return () => playerController.removeListener(listener);
      },
      [playerController],
    );

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
        if (info.visibleFraction <= 0.5) {
          if (playerController.value.isInitialized && playerController.value.isPlaying) {
            playerController.pause();
          }
        } else if (playerController.value.isInitialized &&
            playerController.value.isPlaying == false) {
          playerController.play();
        }
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (isPlaying.value) {
                playerController.pause();
              } else {
                playerController.play();
              }
            },
            child: Center(
              child: AspectRatio(
                aspectRatio: playerController.value.aspectRatio,
                child: CachedVideoPlayerPlus(playerController),
              ),
            ),
          ),
          if (!isPlaying.value)
            Center(
              child: VideoButton(
                size: 48.0.s,
                borderRadius: BorderRadius.circular(20.0.s),
                icon: Assets.svg.iconVideoPlay.icon(
                  color: context.theme.appColors.secondaryBackground,
                  size: 30.0.s,
                ),
                onPressed: playerController.play,
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
