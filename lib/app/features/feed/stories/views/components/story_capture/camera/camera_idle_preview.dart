// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/story_control_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/story_gallery_button.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.r.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';
import 'package:ion/generated/assets.gen.dart';

class CameraIdlePreview extends ConsumerWidget {
  const CameraIdlePreview({
    required this.onGallerySelected,
    this.showGalleryButton = true,
    super.key,
  });

  final Future<void> Function(MediaFile) onGallerySelected;
  final bool showGalleryButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camera = ref.watch(cameraControllerNotifierProvider.notifier);

    return Stack(
      children: [
        PositionedDirectional(
          top: 10.0.s,
          start: 10.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconStoryLightning.icon(),
            onPressed: camera.toggleFlash,
          ),
        ),
        PositionedDirectional(
          top: 10.0.s,
          end: 10.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconSheetClose.icon(color: context.theme.appColors.onPrimaryAccent),
            onPressed: () => context.pop(),
          ),
        ),
        PositionedDirectional(
          bottom: 30.0.s,
          end: 16.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconStorySwitchcamera.icon(),
            onPressed: camera.switchCamera,
          ),
        ),
        if (showGalleryButton)
          PositionedDirectional(
            bottom: 30.0.s,
            start: 16.0.s,
            child: StoryGalleryButton(onSelected: onGallerySelected),
          ),
      ],
    );
  }
}
