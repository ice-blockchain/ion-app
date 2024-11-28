// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/core/providers/env_provider.dart';
import 'package:ion/app/features/feed/stories/providers/story_camera_provider.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/story_control_button.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 'package:ve_sdk_flutter/ve_sdk_flutter.dart';

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
                  final filePath =
                      await ref.read(assetFilePathProvider(mediaFiles.first.path).future);

                  if (filePath == null) return;

                  if (MediaType.fromMimeType(mediaFiles.first.mimeType!) == MediaType.video) {
                    final banubaToken =
                        ref.watch(envProvider.notifier).get<String>(EnvVariable.BANUBA_TOKEN);
                    final config = FeaturesConfigBuilder().build();

                    final exportResult = await VeSdkFlutter().openTrimmerScreen(
                      banubaToken,
                      config,
                      [filePath],
                    );

                    final exportedVideoPath = exportResult?.videoSources.first ?? filePath;

                    if (context.mounted) {
                      await StoryPreviewRoute(
                        path: exportedVideoPath,
                        mimeType: mediaFiles.first.mimeType,
                      ).push<void>(context);
                    }
                  } else {
                    if (context.mounted) {
                      await StoryPreviewRoute(
                        path: filePath,
                        mimeType: mediaFiles.first.mimeType,
                      ).push<void>(context);
                    }
                  }
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
