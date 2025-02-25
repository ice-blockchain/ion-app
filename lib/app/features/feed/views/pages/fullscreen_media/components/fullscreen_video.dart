// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_gradient_overlay.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_post_info.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_progress_bar.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideo extends HookConsumerWidget {
  const FullscreenVideo({
    required this.videoUrl,
    required this.eventReference,
    super.key,
  });

  final String videoUrl;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(
      videoControllerProvider(
        videoUrl,
        autoPlay: true,
        looping: true,
      ),
    );

    if (!controller.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const Positioned.fill(child: VideoGradientOverlay()),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.s),
                        child: VideoPostInfo(eventReference: eventReference),
                      ),
                      SizedBox(height: 14.0.s),
                      VideoProgressBar(controller: controller),
                      SizedBox(height: 20.0.s),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.s),
                        child: SafeArea(
                          top: false,
                          child: CounterItemsFooter(
                            eventReference: eventReference,
                            color: context.theme.appColors.onPrimaryAccent,
                            bottomPadding: 0,
                            topPadding: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
