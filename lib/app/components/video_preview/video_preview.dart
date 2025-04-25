// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/placeholder/ion_placeholder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/ion_connect_network_image/ion_connect_network_image.dart';
import 'package:ion/app/features/core/providers/mute_provider.c.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/hooks/use_route_presence.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPreview extends HookConsumerWidget {
  const VideoPreview({
    required this.videoUrl,
    required this.authorPubkey,
    this.thumbnailUrl,
    this.framedEventReference,
    super.key,
  });

  final String videoUrl;
  final String authorPubkey;
  final String? thumbnailUrl;
  final EventReference? framedEventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uniqueId = useRef(UniqueKey().toString());

    final controller = ref
        .watch(
          videoControllerProvider(
            VideoControllerParams(
              sourcePath: videoUrl,
              authorPubkey: authorPubkey,
              looping: true,
              uniqueId: framedEventReference?.encode() ?? '',
            ),
          ),
        )
        .value;

    final isFullyVisible = useState(false);
    final isRouteFocused = useState(true);
    useRoutePresence(
      onBecameInactive: () {
        isRouteFocused.value = false;
      },
      onBecameActive: () {
        isRouteFocused.value = true;
      },
    );

    final isMuted = ref.watch(globalMuteProvider);

    final handleVisibilityChanged = useCallback(
      (VisibilityInfo info) {
        if (context.mounted) {
          isFullyVisible.value = info.visibleFraction == 1;
        }
      },
      [isFullyVisible, context],
    );

    final wasOffScreen = useRef(false);
    useOnInit(
      () {
        if (controller == null || !controller.value.isInitialized) {
          return;
        }
        final shouldBeActive =
            isFullyVisible.value && !controller.value.isPlaying && isRouteFocused.value;
        final shouldBePaused =
            (!isFullyVisible.value || !isRouteFocused.value) && controller.value.isPlaying;
        if (shouldBeActive) {
          controller.play();
        } else if (shouldBePaused && !wasOffScreen.value) {
          controller.pause();
        }
        wasOffScreen.value = !isFullyVisible.value || !isRouteFocused.value;
      },
      [isFullyVisible.value, isRouteFocused.value, controller],
    );

    return VisibilityDetector(
      key: ValueKey(uniqueId),
      onVisibilityChanged: handleVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: context.theme.appColors.primaryBackground,
            ),
          ),
          if (thumbnailUrl != null &&
              (!(controller?.value.isInitialized ?? false) ||
                  (controller?.value.hasError ?? false)))
            Positioned.fill(
              child: _BlurredThumbnail(
                thumbnailUrl: thumbnailUrl!,
                authorPubkey: authorPubkey,
                isLoading: !(controller?.value.hasError ?? false),
              ),
            ),
          if (controller != null && !controller.value.hasError)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: CachedVideoPlayerPlus(controller),
                ),
              ),
            ),
          if (controller != null && controller.value.hasError)
            const Positioned.fill(
              child: IonPlaceholder(),
            ),
          if (controller != null)
            PositionedDirectional(
              bottom: 5.0.s,
              start: 5.0.s,
              end: 5.0.s,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _VideoDurationLabel(controller: controller),
                  _MuteButton(
                    isMuted: isMuted,
                    onToggle: () {
                      ref.read(globalMuteProvider.notifier).toggle();
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _VideoDurationLabel extends StatelessWidget {
  const _VideoDurationLabel({required this.controller});

  final CachedVideoPlayerPlusController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final remaining = controller.value.duration - value.position;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0.s, vertical: 1.0.s),
          decoration: BoxDecoration(
            color: context.theme.appColors.backgroundSheet.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(6.0.s),
          ),
          child: Text(
            formatDuration(remaining),
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.secondaryBackground,
            ),
          ),
        );
      },
    );
  }
}

class _MuteButton extends StatelessWidget {
  const _MuteButton({
    required this.isMuted,
    required this.onToggle,
  });

  final bool isMuted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final icon = isMuted ? Assets.svg.iconChannelMute : Assets.svg.iconChannelUnmute;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: EdgeInsets.all(6.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.backgroundSheet.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12.0.s),
        ),
        child: icon.icon(
          size: 16.0.s,
          color: context.theme.appColors.onPrimaryAccent,
        ),
      ),
    );
  }
}

class _BlurredThumbnail extends HookWidget {
  const _BlurredThumbnail({
    required this.thumbnailUrl,
    required this.authorPubkey,
    required this.isLoading,
  });

  final String thumbnailUrl;
  final String authorPubkey;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isImageLoaded = useState(false);

    useEffect(
      () {
        final imageStream = Image.network(thumbnailUrl).image.resolve(ImageConfiguration.empty);
        final listener = ImageStreamListener((info, _) {
          if (!context.mounted) return;
          isImageLoaded.value = true;
        });

        imageStream.addListener(listener);
        return () => imageStream.removeListener(listener);
      },
      [thumbnailUrl],
    );

    return Stack(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 100),
          opacity: isImageLoaded.value ? 1 : 0,
          child: IonConnectNetworkImage(
            imageUrl: thumbnailUrl,
            authorPubkey: authorPubkey,
            fit: BoxFit.cover,
          ),
        ),
        if (isLoading)
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
