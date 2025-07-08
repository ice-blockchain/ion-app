// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/core/providers/video_player_provider.r.dart';
import 'package:ion/app/features/feed/stories/hooks/use_story_video_playback.dart';
import 'package:ion/app/features/feed/stories/providers/story_viewing_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/user_stories_provider.r.dart';

class VideoStoryViewer extends HookConsumerWidget {
  const VideoStoryViewer({
    required this.videoPath,
    required this.authorPubkey,
    required this.storyId,
    required this.viewerPubkey,
    super.key,
  });

  final String videoPath;
  final String authorPubkey;
  final String storyId;
  final String viewerPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoController = ref
        .watch(
          videoControllerProvider(
            VideoControllerParams(sourcePath: videoPath, authorPubkey: authorPubkey),
          ),
        )
        .value;

    if (videoController == null || !videoController.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    final stories = ref
            .watch(
              userStoriesProvider(
                ref.watch(storyViewingControllerProvider(viewerPubkey)).currentUserPubkey,
              ),
            )
            ?.toList() ??
        [];

    useStoryVideoPlayback(
      ref: ref,
      controller: videoController,
      storyId: storyId,
      viewerPubkey: viewerPubkey,
      onCompleted: () {
        ref
            .read(storyViewingControllerProvider(viewerPubkey).notifier)
            .advance(stories: stories, onClose: () => context.pop());
      },
    );

    Widget videoPlayer = CachedVideoPlayerPlus(videoController);

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
