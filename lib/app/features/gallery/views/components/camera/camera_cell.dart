// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/views/permission_aware_widget.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:ice/app/features/gallery/views/components/camera/camera.dart';

class CameraCell extends HookConsumerWidget {
  const CameraCell({super.key});

  static double get cellHeight => 120.0.s;
  static double get cellWidth => 122.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerNotifier = ref.watch(cameraControllerNotifierProvider.notifier);
    final cameraControllerAsync = ref.watch(cameraControllerNotifierProvider);

    useEffect(
      () {
        final observer = _CameraLifecycleObserver(
          onResume: cameraControllerNotifier.resumeCamera,
          onPause: cameraControllerNotifier.pauseCamera,
        );
        WidgetsBinding.instance.addObserver(observer);

        return () {
          WidgetsBinding.instance.removeObserver(observer);
        };
      },
      [],
    );

    return PermissionAwareWidget(
      permissionType: AppPermissionType.camera,
      buildWithoutPermission: (_) => const CameraPlaceholderWidget(),
      buildWithPermission: (BuildContext context) {
        return cameraControllerAsync.maybeWhen(
          data: (controller) {
            final isInitialized = controller?.value.isInitialized ?? false;

            return GestureDetector(
              onTap: () async => ref.read(galleryNotifierProvider.notifier).captureImage(),
              child: SizedBox(
                width: cellWidth,
                height: cellHeight,
                child: isInitialized && controller != null
                    ? CameraPreviewWidget(controller: controller)
                    : const CameraPlaceholderWidget(),
              ),
            );
          },
          orElse: () => const CameraPlaceholderWidget(),
        );
      },
    );
  }
}

class _CameraLifecycleObserver extends WidgetsBindingObserver {
  _CameraLifecycleObserver({required this.onResume, required this.onPause});
  final VoidCallback onResume;
  final VoidCallback onPause;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    return switch (state) {
      AppLifecycleState.hidden => null,
      AppLifecycleState.resumed => onResume(),
      AppLifecycleState.inactive ||
      AppLifecycleState.paused ||
      AppLifecycleState.detached =>
        onPause()
    };
  }
}
