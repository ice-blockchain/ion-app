// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/providers/camera_actions_provider.c.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/story_control_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/story_gallery_button.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class CameraIdlePreview extends ConsumerWidget {
  const CameraIdlePreview({
    super.key,
    this.showGalleryButton = true,
  });

  final bool showGalleryButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraActionsNotifier = ref.watch(cameraActionsControllerProvider.notifier);

    return Stack(
      children: [
        Positioned(
          top: 10.0.s,
          left: 10.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconSheetClose.icon(color: context.theme.appColors.onPrimaryAccent),
            onPressed: () => context.pop(),
          ),
        ),
        Positioned(
          top: 10.0.s,
          right: 10.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconStoryLightning.icon(),
            onPressed: cameraActionsNotifier.toggleFlash,
          ),
        ),
        Positioned(
          bottom: 30.0.s,
          right: 16.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconStorySwitchcamera.icon(),
            onPressed: () => ref.read(cameraControllerNotifierProvider.notifier).switchCamera(),
          ),
        ),
        if (showGalleryButton)
          Positioned(
            bottom: 30.0.s,
            left: 16.0.s,
            child: const StoryGalleryButton(),
          ),
      ],
    );
  }
}
