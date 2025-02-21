// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideo extends HookConsumerWidget {
  const FullscreenVideo({
    required this.videoUrl,
    super.key,
  });

  final String videoUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(videoControllerProvider(videoUrl, autoPlay: true));

    useEffect(
      () {
        if (controller.value.isInitialized) {
          controller
            ..setLooping(true)
            ..play();
        }
        return null;
      },
      [controller],
    );

    if (!controller.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }
}
