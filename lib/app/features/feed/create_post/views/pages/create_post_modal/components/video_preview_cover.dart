// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/video_preview_duration.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/video_preview_edit_cover.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewCover extends HookConsumerWidget {
  const VideoPreviewCover({
    required this.videoPath,
    super.key,
  });

  final String videoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeholderWidth = MediaQuery.sizeOf(context).width - 48.0.s;

    final assetFilePathAsync = ref.watch(assetFilePathProvider(videoPath));

    final filePath = assetFilePathAsync.valueOrNull;

    if (filePath == null) {
      return const SizedBox.shrink();
    }

    final videoController = ref.watch(
      videoControllerProvider(
        filePath,
        autoPlay: true,
        looping: true,
      ),
    );

    if (!videoController.value.isInitialized) {
      return const SizedBox.shrink();
    }

    useOnInit(videoController.play);

    useEffect(
      () {
        return videoController.dispose;
      },
      [videoController],
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0.s),
      child: SizedBox(
        width: placeholderWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ColoredBox(
              color: Colors.amber,
              child: AspectRatio(
                aspectRatio: 280 / 430,
                child: (videoController.value.isInitialized)
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: videoController.value.size.width,
                          height: videoController.value.size.height,
                          child: VideoPlayer(videoController),
                        ),
                      )
                    : Container(
                        color: Colors.black,
                      ),
              ),
            ),
            Center(
              child: Container(
                width: 48.0.s,
                height: 48.0.s,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0.s),
                  color: context.theme.appColors.primaryAccent,
                ),
                child: ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: videoController,
                  builder: (context, value, child) {
                    return IconButton(
                      icon: value.isPlaying
                          ? Assets.svg.iconVideoPause
                              .icon(color: context.theme.appColors.secondaryBackground)
                          : Assets.svg.iconVideoPlay
                              .icon(color: context.theme.appColors.secondaryBackground),
                      onPressed: () {
                        if (value.isPlaying) {
                          videoController.pause();
                        } else {
                          videoController.play();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            // assetFilePathAsync.maybeWhen(
            //   data: (filePath) {
            //     if (filePath == null) {
            //       return const CenteredLoadingIndicator();
            //     }

            //     final videoController = ref.read(
            //       videoControllerProvider(
            //         filePath,
            //         autoPlay: true,
            //         looping: true,
            //       ),
            //     );

            //     if (!videoController.value.isInitialized) {
            //       return const CenteredLoadingIndicator();
            //     }

            //     final videoAspectRatio = videoController.value.aspectRatio;

            //     return AspectRatio(
            //       aspectRatio: videoAspectRatio,
            //       child: VideoPlayer(videoController),
            //     );
            //   },
            //   orElse: () => const CenteredLoadingIndicator(),
            // ),
            Positioned(
              right: 12.0.s,
              bottom: 12.0.s,
              child: const VideoPreviewEditCover(),
            ),
            Positioned(
              left: 12.0.s,
              bottom: 12.0.s,
              child: VideoPreviewDuration(duration: videoController.value.duration.inSeconds),
            ),
          ],
        ),
      ),
    );
  }
}
