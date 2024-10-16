// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/create_story/providers/story_camera_provider.dart';
import 'package:ice/app/features/feed/create_story/views/components/story_camera/camera_control_button.dart';
import 'package:ice/app/features/gallery/providers/camera_provider.dart';
import 'package:ice/generated/assets.gen.dart';

class IdleCameraPreview extends ConsumerWidget {
  const IdleCameraPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyCameraNotifier = ref.read(storyCameraControllerProvider.notifier);

    return Stack(
      children: [
        Positioned(
          top: 10.0.s,
          left: 10.0.s,
          child: CameraControlButton(
            icon: Assets.svg.iconSheetClose.icon(color: context.theme.appColors.onPrimaryAccent),
            onPressed: () => context.pop(),
          ),
        ),
        Positioned(
          top: 10.0.s,
          right: 10.0.s,
          child: CameraControlButton(
            icon: Assets.svg.iconStoryLightning.icon(),
            onPressed: storyCameraNotifier.toggleFlash,
          ),
        ),
        Positioned(
          bottom: 30.0.s,
          right: 16.0.s,
          child: CameraControlButton(
            icon: Assets.svg.iconStorySwitchcamera.icon(),
            onPressed: () => ref.read(cameraControllerNotifierProvider.notifier).switchCamera(),
          ),
        ),
        // TODO: Implement the open gallery button
        Positioned(
          bottom: 30.0.s,
          left: 16.0.s,
          child: CameraControlButton(
            icon: Assets.svg.iconGalleryOpen.icon(color: context.theme.appColors.onPrimaryAccent),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
