// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.c.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/gallery/views/components/camera/camera.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';

class CameraCell extends HookConsumerWidget {
  const CameraCell({required this.type, super.key});

  final MediaPickerType type;

  static double get cellHeight => 120.0.s;
  static double get cellWidth => 122.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPermission = ref.watch(hasPermissionProvider(Permission.camera));
    final cameraControllerNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    final shouldOpenCamera = useState(false);

    ref
      ..listen<bool>(
        hasPermissionProvider(Permission.camera),
        (previous, next) async {
          final wasResumed = await cameraControllerNotifier.handlePermissionChange(
            hasPermission: next,
          );

          if (wasResumed) {
            shouldOpenCamera.value = true;
          }
        },
      )
      ..listen<CameraState>(
        cameraControllerNotifierProvider,
        (previous, next) async {
          await next.whenOrNull(
            ready: (_, __, ___) async {
              if (shouldOpenCamera.value) {
                shouldOpenCamera.value = false;

                final mediaFile =
                    await GalleryCameraRoute(mediaPickerType: type).push<MediaFile?>(context);

                if (mediaFile != null) {
                  final galleryNotifier = ref.read(galleryNotifierProvider(type: type).notifier);
                  await galleryNotifier.addCapturedMediaFileToGallery(mediaFile);
                }
              }
            },
          );
        },
      );

    return PermissionAwareWidget(
      permissionType: Permission.camera,
      onGranted: () async {
        await ref.read(cameraControllerNotifierProvider).maybeWhen(
          ready: (_, __, ___) async {
            final mediaFile =
                await GalleryCameraRoute(mediaPickerType: type).push<MediaFile?>(context);

            if (mediaFile != null) {
              final galleryNotifier = ref.read(galleryNotifierProvider(type: type).notifier);
              await galleryNotifier.addCapturedMediaFileToGallery(mediaFile);
            }
          },
          orElse: () {
            shouldOpenCamera.value = true;
            cameraControllerNotifier.resumeCamera();
          },
        );
      },
      requestDialog: const PermissionRequestSheet(permission: Permission.camera),
      settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
      builder: (context, onPressed) {
        return SizedBox(
          width: cellWidth,
          height: cellHeight,
          child: GestureDetector(
            onTap: onPressed,
            child: !hasPermission
                ? const CameraPlaceholderWidget()
                : ref.watch(cameraControllerNotifierProvider).maybeWhen(
                      ready: (controller, _, ___) {
                        return CameraPreviewWidget(
                          key: ValueKey(controller),
                          controller: controller,
                        );
                      },
                      orElse: () => const CameraPlaceholderWidget(),
                    ),
          ),
        );
      },
    );
  }
}
