// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/providers/video_player_provider.dart';
import 'package:ice/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:video_player/video_player.dart';

class StoryVideoPreview extends ConsumerWidget {
  const StoryVideoPreview({required this.videoPath, super.key});

  final String videoPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetFilePathAsync = ref.watch(assetFilePathProvider(videoPath));

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(22.0.s),
            child: assetFilePathAsync.maybeWhen(
              data: (filePath) {
                if (filePath == null) {
                  return const Center(child: IceLoadingIndicator());
                }

                final videoController = ref.watch(
                  videoControllerProvider(
                    filePath,
                    autoPlay: true,
                    looping: true,
                  ),
                );

                if (!videoController.value.isInitialized) {
                  return const Center(child: IceLoadingIndicator());
                }

                final videoAspectRatio = videoController.value.aspectRatio;

                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth / videoAspectRatio,
                  child: VideoPlayer(videoController),
                );
              },
              orElse: () => const Center(child: IceLoadingIndicator()),
            ),
          );
        },
      ),
    );
  }
}
