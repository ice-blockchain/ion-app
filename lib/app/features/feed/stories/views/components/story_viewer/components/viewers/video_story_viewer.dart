// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/core/providers/video_player_provider.r.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_video_playback.dart';
import 'package:video_player/video_player.dart';

class VideoStoryViewer extends HookConsumerWidget {
  const VideoStoryViewer({
    required this.videoPath,
    required this.authorPubkey,
    required this.storyId,
    required this.viewerPubkey,
    required this.onVideoCompleted,
    super.key,
  });

  final String videoPath;
  final String authorPubkey;
  final String storyId;
  final String viewerPubkey;
  final VoidCallback onVideoCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = ref
        .watch(
          videoControllerProvider(
            VideoControllerParams(sourcePath: videoPath, authorPubkey: authorPubkey),
          ),
        )
        .valueOrNull;

    if (videoController == null || !videoController.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    useStoryVideoPlayback(
      ref: ref,
      controller: videoController,
      storyId: storyId,
      viewerPubkey: viewerPubkey,
      onCompleted: onVideoCompleted,
    );

    Widget videoPlayer = VideoPlayer(videoController);

    final aspect = videoController.value.aspectRatio;
    final isHorizontal = aspect > 1.0;
    if (isHorizontal) {
      videoPlayer = Center(
        child: AspectRatio(
          aspectRatio: aspect,
          child: videoPlayer,
        ),
      );
    }
    return videoPlayer;
  }
}
