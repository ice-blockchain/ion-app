// SPDX-License-Identifier: ice License 1.0

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/video/views/components/video_button.dart';
import 'package:ion/app/features/video/views/components/video_post_info.dart';
import 'package:ion/app/features/video/views/components/video_progress.dart';
import 'package:ion/app/features/video/views/components/video_slider.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

    final isMuted = ref.watch(globalMuteProvider);

    useOnInit(
      () => controller.setVolume(isMuted ? 0 : 1),
      [isMuted],
    );

    ref.listen(appLifecycleProvider, (_, current) async {
      if (current == AppLifecycleState.resumed) {
        await controller.play();
      } else if (current == AppLifecycleState.inactive ||
          current == AppLifecycleState.paused ||
          current == AppLifecycleState.hidden) {
        await controller.pause();
      }
    });

    if (!controller.value.isInitialized) {
      return const CenteredLoadingIndicator();
    }

    return VisibilityDetector(
      key: ValueKey(videoUrl),
      onVisibilityChanged: (info) {
        if (!context.mounted) return;

        info.visibleFraction == 0 ? controller.pause() : controller.play();
      },
      child: Column(
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
                      child: CachedVideoPlayerPlus(controller),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Stack(
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final postEntity =
                              ref.watch(ionConnectEntityProvider(eventReference: eventReference));
                          final post = postEntity.valueOrNull as ModifiablePostEntity?;

                          if (post == null) return const SizedBox.shrink();

                          return VideoPostInfo(videoPost: post);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16.0.s,
                  bottom: 86.0.s,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final isMuted = ref.watch(globalMuteProvider);
                      return VideoButton(
                        icon: isMuted
                            ? Assets.svg.iconChannelMute.icon(
                                color: context.theme.appColors.secondaryBackground,
                                size: 20.0.s,
                              )
                            : Assets.svg.iconChannelUnmute.icon(
                                color: context.theme.appColors.secondaryBackground,
                                size: 20.0.s,
                              ),
                        onPressed: () => ref.read(globalMuteProvider.notifier).toggle(),
                      );
                    },
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
      ),
    );
  }
}
