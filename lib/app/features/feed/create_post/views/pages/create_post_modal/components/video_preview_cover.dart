// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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

  static const double minAspectRatio = 9 / 16;
  static const double maxAspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPlayButton = useState(true);

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

    final videoSize = videoController.value.size;
    final videoAspectRatio = videoSize.width / videoSize.height;

    final clampedAspectRatio = videoAspectRatio.clamp(minAspectRatio, maxAspectRatio);

    return Padding(
      padding: EdgeInsets.only(bottom: 24.0.s, left: 12.0.s, right: 12.0.s),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 430.0.s),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0.s),
          child: AspectRatio(
            aspectRatio: clampedAspectRatio,
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
                    child: VideoPreviewDuration(
                      duration: Duration(seconds: videoController.value.duration.inSeconds),
                    ),
                  ),
                ],
              ),
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