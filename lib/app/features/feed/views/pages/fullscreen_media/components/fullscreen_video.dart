// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_gradient_overlay.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_post_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/video/views/components/video_progress.dart';
import 'package:ion/app/features/video/views/components/video_slider.dart';
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

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Stack(
                  children: [
                    const Positioned.fill(child: VideoGradientOverlay()),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14.0.s,
                        horizontal: 16.0.s,
                      ),
                      child: VideoPostInfo(eventReference: eventReference),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        VideoProgress(
          controller: controller,
          builder: (context, position, duration) => VideoSlider(
            position: position,
            duration: duration,
            onChangeStart: (_) => controller.pause(),
            onChangeEnd: (_) => controller.play(),
            onChanged: (value) {
              if (controller.value.isInitialized) {
                controller.seekTo(
                  Duration(milliseconds: value.toInt()),
                );
              }
            },
          ),
        ),
        SizedBox(height: 20.0.s),
        ColoredBox(
          color: context.theme.appColors.primaryText,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        ),
      ],
    );
  }
}
