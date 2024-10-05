// SPDX-License-Identifier: ice License 1.0

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/providers/permissions_provider.dart';
import 'package:ice/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ice/app/features/core/permissions/views/components/permission_dialogs/permission_sheets.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:ice/app/features/gallery/views/components/camera/camera.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class CameraCell extends HookConsumerWidget {
  const CameraCell({super.key});

  static double get cellHeight => 120.0.s;
  static double get cellWidth => 122.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPermission = ref.watch(hasPermissionProvider(Permission.camera));
    final cameraControllerNotifier = ref.read(cameraControllerNotifierProvider.notifier);
    final shouldOpenCamera = useState(false);

    useOnAppLifecycleStateChange((_, AppLifecycleState current) async {
      if (current == AppLifecycleState.resumed && hasPermission) {
        await cameraControllerNotifier.resumeCamera();
      } else if (current == AppLifecycleState.inactive ||
          current == AppLifecycleState.paused ||
          current == AppLifecycleState.hidden) {
        await cameraControllerNotifier.pauseCamera();
      }
    });

    ref
      ..listen<bool>(
        hasPermissionProvider(Permission.camera),
        (previous, next) {
          if (next) {
            cameraControllerNotifier.resumeCamera();
            shouldOpenCamera.value = true;
          } else {
            cameraControllerNotifier.pauseCamera();
          }
        },
      )
      ..listen<AsyncValue<Raw<CameraController>?>>(
        cameraControllerNotifierProvider,
        (previous, next) {
          next.maybeWhen(
            data: (controller) async {
              final isInitialized = controller?.value.isInitialized ?? false;
              if (isInitialized && shouldOpenCamera.value) {
                shouldOpenCamera.value = false;
                await ref.read(galleryNotifierProvider.notifier).captureImage();
              }
            },
            orElse: () {},
          );
        },
      );

    return PermissionAwareWidget(
      permissionType: Permission.camera,
      onGranted: () async {
        final cameraControllerAsync = ref.read(cameraControllerNotifierProvider);
        final isInitialized = cameraControllerAsync.value?.value.isInitialized ?? false;

        if (isInitialized) {
          await ref.read(galleryNotifierProvider.notifier).captureImage();
        } else {
          shouldOpenCamera.value = true;
          await cameraControllerNotifier.resumeCamera();
        }
      },
      requestDialog: PermissionRequestSheet.fromType(context, Permission.camera),
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
                      data: (controller) {
                        final isInitialized = controller?.value.isInitialized ?? false;

                        return isInitialized && controller != null
                            ? CameraPreviewWidget(controller: controller)
                            : const CameraPlaceholderWidget();
                      },
                      orElse: () => const CameraPlaceholderWidget(),
                    ),
          ),
        );
      },
    );
  }
}
