// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/video/views/components/video_button.dart';
import 'package:ion/app/features/video/views/components/video_progress.dart';
import 'package:ion/app/features/video/views/components/video_slider.dart';
import 'package:ion/app/features/video/views/components/video_thumbnail_preview.dart';
import 'package:ion/app/features/video/views/hooks/use_video_ended.dart';
import 'package:ion/app/hooks/use_route_presence.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPage extends HookConsumerWidget {
  const VideoPage({
    required this.videoUrl,
    this.onVideoEnded,
    this.authorPubkey,
    this.looping = false,
    this.framedEventReference,
    this.videoInfo,
    this.bottomOverlay,
    this.videoBottomPadding = 42.0,
    this.thumbnailUrl,
    this.blurhash,
    this.aspectRatio,
    super.key,
  });

  final VoidCallback? onVideoEnded;
  final String videoUrl;
  final String? authorPubkey;
  final EventReference? framedEventReference;
  final bool looping;
  final Widget? videoInfo;
  final Widget? bottomOverlay;
  final double videoBottomPadding;
  final String? thumbnailUrl;
  final String? blurhash;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (videoUrl.isEmpty) {
      return Text(context.i18n.video_not_found);
    }

    final playerController = ref
        .watch(
          videoControllerProvider(
            VideoControllerParams(
              sourcePath: videoUrl,
              authorPubkey: authorPubkey,
              autoPlay: true,
              looping: looping,
              uniqueId: framedEventReference?.encode() ?? '',
            ),
          ),
        )
        .value;

    if (playerController == null || !playerController.value.isInitialized) {
      final thumbnailAspectRatio = aspectRatio ?? 16 / 9;

      Widget thumbnailWidget = VideoThumbnailPreview(
        thumbnailUrl: thumbnailUrl,
        blurhash: blurhash,
        authorPubkey: authorPubkey,
      );

      if (thumbnailAspectRatio < 1) {
        thumbnailWidget = SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: thumbnailWidget,
          ),
        );
      } else {
        thumbnailWidget = Center(
          child: AspectRatio(
            aspectRatio: thumbnailAspectRatio,
            child: thumbnailWidget,
          ),
        );
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          thumbnailWidget,
          const CenteredLoadingIndicator(),
        ],
      );
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

    useRoutePresence(
      onBecameInactive: () {
        if (playerController.value.isPlaying) {
          playerController.pause();
        }
      },
      onBecameActive: () {
        if (playerController.value.isInitialized && !playerController.value.isPlaying) {
          playerController.play();
        }
      },
    );

    ref.listen(appLifecycleProvider, (_, current) {
      if (!context.mounted) return;

      if (current == AppLifecycleState.resumed) {
        playerController.play();
      } else if (current == AppLifecycleState.paused || current == AppLifecycleState.hidden) {
        playerController.pause();
      }
    });

    Widget videoPlayer = SizedBox(
      height: playerController.value.size.height,
      width: playerController.value.size.width,
      child: CachedVideoPlayerPlus(playerController),
    );

    if (playerController.value.aspectRatio < 1) {
      videoPlayer = SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: videoPlayer,
        ),
      );
    } else {
      videoPlayer = AspectRatio(
        aspectRatio: playerController.value.aspectRatio,
        child: videoPlayer,
      );
    }

    return VisibilityDetector(
      key: ValueKey(videoUrl),
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
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(bottom: videoBottomPadding.s),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: videoPlayer,
                  ),
                ),
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
                if (videoInfo != null) videoInfo!,
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
                if (bottomOverlay != null) bottomOverlay!,
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ColoredBox(
              color: context.theme.appColors.primaryText,
              child: SizedBox(
                height: MediaQuery.paddingOf(context).bottom,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
