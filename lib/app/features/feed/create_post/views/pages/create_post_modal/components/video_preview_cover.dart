// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/video_preview_duration.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/video_preview_edit_cover.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewCover extends HookConsumerWidget {
  const VideoPreviewCover({
    this.videoPath,
    super.key,
  });

  final String? videoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeholderWidth = MediaQuery.sizeOf(context).width - 48.0.s;

    final videoController = ref.watch(
      videoControllerProvider(Assets.videos.articlePreview, looping: true),
    );

    useOnInit(videoController.play);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0.s),
      child: SizedBox(
        width: placeholderWidth,
        child: Stack(
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
              child: const VideoPreviewDuration(duration: 70), //TODO: Get duration from video
            ),
          ],
        ),
      ),
    );
  }
}
