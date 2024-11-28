// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/mute_provider.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/video/views/components/video_header.dart';
import 'package:ion/app/features/video/views/components/video_post_info.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends HookConsumerWidget {
  const VideoPage({
    required this.video,
    super.key,
  });

  final PostEntity video;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMuted = ref.watch(globalMuteProvider);

    final videoPath = video.data.primaryMedia?.url;
    if (videoPath == null || videoPath.isEmpty) {
      return Text(context.i18n.video_not_found);
    }
    final playerController = ref.watch(
      videoControllerProvider(
        videoPath,
        autoPlay: true,
      ),
    );

    if (!playerController.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    useOnInit(
      () => playerController.setVolume(isMuted ? 0 : 1),
      [isMuted],
    );

    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: playerController.value.aspectRatio,
            child: VideoPlayer(playerController),
          ),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VideoHeader(),
              const Spacer(),
              VideoPostInfo(videoPost: video),
            ],
          ),
        ),
      ],
    );
  }
}
