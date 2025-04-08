// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';

class StoryVideoPreview extends ConsumerWidget {
  const StoryVideoPreview({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = ref
        .watch(
          videoControllerProvider(
            VideoControllerParams(sourcePath: path, autoPlay: true, looping: true),
          ),
        )
        .value;

    if (videoController == null || !videoController.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(22.0.s),
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxWidth / videoController.value.aspectRatio,
            child: CachedVideoPlayerPlus(videoController),
          ),
        );
      },
    );
  }
}
