// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/stories/data/models/story.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:video_player/video_player.dart';

class VideoStoryViewer extends HookConsumerWidget {
  const VideoStoryViewer({
    required this.videoPath,
    required this.muteState,
    super.key,
  });

  final String videoPath;
  final MuteState muteState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = ref.watch(
      videoControllerProvider(
        videoPath,
        autoPlay: true,
      ),
    );

    if (!videoController.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    useOnInit(
      () => videoController.setVolume(muteState == MuteState.muted ? 0 : 1),
      [muteState],
    );

    final videoAspectRatio = videoController.value.aspectRatio;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth / videoAspectRatio,
          child: VideoPlayer(videoController),
        );
      },
    );
  }
}
