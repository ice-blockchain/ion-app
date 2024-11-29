// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/video_preview_duration.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/video_preview_edit_cover.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
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
    final assetFilePathAsync = ref.watch(assetFilePathProvider(videoPath));
    final filePath = assetFilePathAsync.valueOrNull;

    if (filePath == null) {
      return const _VideoPlaceholder();
    }

    final videoController = ref.watch(
      videoControllerProvider(
        filePath,
        looping: true,
      ),
    );

    if (!videoController.value.isInitialized) {
      return const _VideoPlaceholder();
    }

    useEffect(
      () {
        return videoController.dispose;
      },
      [videoController],
    );

    final videoWidth = videoController.value.size.width;
    final videoHeight = videoController.value.size.height;
    final aspectRatio = videoWidth / videoHeight;

    final maxWidth = MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultMediumMargin * 2;
    final calculatedHeight = maxWidth / aspectRatio;
    final constrainedHeight = calculatedHeight.clamp(0.0, 430.0.s);

    final showPlayButton = useState(true);

    return Padding(
      padding: EdgeInsets.only(bottom: 24.0.s),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0.s),
        child: SizedBox(
          width: maxWidth,
          height: constrainedHeight,
          child: GestureDetector(
            onTap: () {
              if (videoController.value.isPlaying) {
                videoController.pause();
                showPlayButton.value = true;
              } else {
                videoController.play();
                showPlayButton.value = false;
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(videoController),
                if (showPlayButton.value)
                  Container(
                    width: 48.0.s,
                    height: 48.0.s,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.0.s),
                      color: context.theme.appColors.primaryAccent,
                    ),
                    child: IconButton(
                      icon: Assets.svg.iconVideoPlay
                          .icon(color: context.theme.appColors.secondaryBackground),
                      onPressed: () {
                        videoController.play();
                        showPlayButton.value = false;
                      },
                    ),
                  ),
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
        ),
      ),
    );
  }
}

class _VideoPlaceholder extends StatelessWidget {
  const _VideoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.0.s),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 180.0.s,
          maxHeight: 430.0.s,
        ),
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
