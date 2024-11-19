// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/feed/stories/providers/story_camera_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/story_control_button.dart';
import 'package:ion/app/features/feed/stories/views/pages/story_preview_page.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';

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
            onPressed: storyCameraNotifier.toggleFlash,
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
        Positioned(
          bottom: 30.0.s,
          left: 16.0.s,
          child: PermissionAwareWidget(
            permissionType: Permission.photos,
            onGranted: () async {
              if (context.mounted) {
                final mediaFiles =
                    await MediaPickerRoute(maxSelection: 1).push<List<MediaFile>>(context);

                if (mediaFiles != null && mediaFiles.isNotEmpty && context.mounted) {
                  await StoryPreviewRoute(
                    path: mediaFiles.first.path,
                    storyType: StoryType.image,
                  ).push<void>(context);
                }
              }
            },
            requestDialog: const PermissionRequestSheet(
              permission: Permission.photos,
            ),
            settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
            builder: (context, onPressed) => StoryControlButton(
              onPressed: onPressed,
              icon: Assets.svg.iconGalleryOpen.icon(
                color: context.theme.appColors.onPrimaryAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
