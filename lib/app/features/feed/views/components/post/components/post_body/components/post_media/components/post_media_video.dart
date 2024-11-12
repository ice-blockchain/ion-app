// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/video_preview/video_preview.dart';
import 'package:ion/app/features/core/providers/video_player_provider.dart';

class PostMediaVideo extends HookConsumerWidget {
  const PostMediaVideo({required this.videoUrl, super.key});

  final String videoUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final videoController = ref.watch(
      videoControllerProvider(
        videoUrl,
        looping: true,
      ),
    );
    return VideoPreview(controller: videoController);
  }
}
