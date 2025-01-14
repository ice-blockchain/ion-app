// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/video_player_provider.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPreview extends HookConsumerWidget {
  const VideoPreview({
    required this.videoUrl,
    this.thumbnailUrl,
    this.videoController,
    super.key,
  });

  final String videoUrl;
  final String? thumbnailUrl;
  final VideoPlayerController? videoController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = videoController ??
        ref.watch(
          videoControllerProvider(
            videoUrl,
            looping: true,
          ),
        )!;

    final isMuted = useState(true);

    return VisibilityDetector(
      key: ValueKey(controller.dataSource),
      onVisibilityChanged: (info) {
        if (!context.mounted || !controller.value.isInitialized) return;

        if (info.visibleFraction == 0) {
          controller
            ..pause()
            ..setVolume(0);
          isMuted.value = true;
        } else {
          controller.play();
        }
      },
      child: Stack(
        children: [
          if (thumbnailUrl != null)
            Positioned.fill(
              child: _BlurredThumbnail(
                thumbnailUrl: thumbnailUrl!,
                isVisible: !controller.value.isInitialized,
              ),
            ),
          Positioned.fill(
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
            bottom: 5.0.s,
            left: 5.0.s,
            right: 5.0.s,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _VideoDurationLabel(duration: controller.value.duration),
                _MuteButton(
                  isMuted: isMuted.value,
                  onToggle: () {
                    isMuted.value = !isMuted.value;
                    controller.setVolume(isMuted.value ? 0 : 1);
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
  const _VideoDurationLabel({
    required this.duration,
  });

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0.s, vertical: 1.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.backgroundSheet.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6.0.s),
      ),
      child: Text(
        formatDuration(duration),
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.secondaryBackground,
        ),
      ),
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
    required this.isVisible,
  });

  final String thumbnailUrl;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final imageAspectRatio = useState<double?>(null);
    final isImageLoaded = useState(false);

    useEffect(
      () {
        final imageStream = Image.network(thumbnailUrl).image.resolve(ImageConfiguration.empty);
        final listener = ImageStreamListener((info, _) {
          if (!context.mounted) return;

          imageAspectRatio.value = info.image.width / info.image.height;
          isImageLoaded.value = true;
        });

        imageStream.addListener(listener);
        return () => imageStream.removeListener(listener);
      },
      [thumbnailUrl],
    );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isVisible ? 1 : 0,
      curve: Curves.easeInOut,
      child: AspectRatio(
        aspectRatio: imageAspectRatio.value ?? 16 / 9,
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isImageLoaded.value ? 1 : 0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
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
        ),
      ),
    );
  }
}
