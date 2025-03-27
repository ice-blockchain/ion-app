// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/gallery/data/models/camera_state.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:mime/mime.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_provider.c.g.dart';

@riverpod
class CameraControllerNotifier extends _$CameraControllerNotifier {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  CameraDescription? _frontCamera;
  CameraDescription? _backCamera;

  void _onCameraControllerUpdate() => ref.notifyListeners();

  @override
  CameraState build() {
    ref
      ..onDispose(_disposeCamera)
      ..listen(appLifecycleProvider, (previous, current) async {
        final hasPermission = ref.read(hasPermissionProvider(Permission.camera));

        if (current == AppLifecycleState.resumed && hasPermission) {
          await resumeCamera();
        } else if (current == AppLifecycleState.inactive ||
            current == AppLifecycleState.paused ||
            current == AppLifecycleState.hidden) {
          await pauseCamera();
        }
      });

    final hasPermission = ref.watch(hasPermissionProvider(Permission.camera));

    if (!hasPermission) {
      return const CameraState.initial();
    }

    _initializeCamera();
    return const CameraState.initial();
  }

  Future<void> _initializeCamera() async {
    state = const CameraState.loading();
    try {
      _cameras = await availableCameras();

      _backCamera = _cameras?.firstWhereOrNull(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _frontCamera = _cameras?.firstWhereOrNull(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      final initialCamera = _backCamera ?? _frontCamera;

      if (initialCamera == null) {
        Logger.log('Camera not found');
        state = const CameraState.error(message: 'Camera not found');
        return;
      }

      final controller = await _createCameraController(initialCamera);
      state = CameraState.ready(controller: controller);
    } catch (e) {
      Logger.log('Camera initialization error: $e');
      state = CameraState.error(message: 'Camera initialization error: $e');
    }
  }

  Future<CameraController> _createCameraController(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );

    try {
      await _cameraController?.initialize();
      _cameraController?.addListener(_onCameraControllerUpdate);
      return _cameraController!;
    } catch (e) {
      Logger.log('Camera initialization error: $e');
      await _disposeCamera();
      throw Exception('Camera initialization error: $e');
    }
  }

  Future<void> pauseCamera() async {
    if (_cameraController != null) {
      _cameraController?.removeListener(_onCameraControllerUpdate);
      await _disposeCamera();
      state = const CameraState.initial();
    }
  }

  Future<bool> resumeCamera() async {
    final hasPermission = ref.read(hasPermissionProvider(Permission.camera));

    if (!hasPermission) {
      return false;
    }

    final shouldSkipInitialization = state.maybeWhen(
      loading: () => true,
      ready: (_, __, ___) => true,
      orElse: () => false,
    );

    if (shouldSkipInitialization) {
      return state.maybeWhen(
        ready: (_, __, ___) => true,
        orElse: () => false,
      );
    }

    await _initializeCamera();
    return state is CameraReady;
  }

  Future<bool> handlePermissionChange({required bool hasPermission}) async {
    if (hasPermission) {
      return resumeCamera();
    } else {
      await pauseCamera();
      return false;
    }
  }

  Future<void> switchCamera() async {
    if (_cameraController == null) return;

    final currentCamera = _cameraController!.description;
    final newCamera =
        currentCamera.lensDirection == CameraLensDirection.back ? _frontCamera : _backCamera;

    if (newCamera == null) return;

    await pauseCamera();
    state = const CameraState.loading();
    try {
      final controller = await _createCameraController(newCamera);
      state = CameraState.ready(controller: controller);
    } catch (e) {
      state = CameraState.error(message: 'Camera switch error: $e');
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    await state.maybeWhen(
      ready: (controller, isRecording, isFlashOn) async {
        try {
          await controller.setFlashMode(mode);
          state = CameraState.ready(
            controller: controller,
            isRecording: isRecording,
            isFlashOn: mode == FlashMode.torch,
          );
        } catch (e) {
          Logger.log('Error setting flash mode', error: e);
          state = CameraState.error(message: 'Error setting flash mode: $e');
        }
      },
      orElse: () {},
    );
  }

  Future<void> toggleFlash() async {
    await state.maybeWhen(
      ready: (controller, isRecording, isFlashOn) async {
        final newFlashMode = isFlashOn ? FlashMode.off : FlashMode.torch;
        try {
          await controller.setFlashMode(newFlashMode);
          state = CameraState.ready(
            controller: controller,
            isRecording: isRecording,
            isFlashOn: !isFlashOn,
          );
        } catch (e) {
          Logger.log('Error toggling flash mode', error: e);
          state = CameraState.error(message: 'Error toggling flash mode: $e');
        }
      },
      orElse: () {},
    );
  }

  Future<XFile?> takePicture() async {
    if (_cameraController == null) return null;

    try {
      final picture = await _cameraController!.takePicture();
      return picture;
    } catch (e) {
      Logger.log('Error taking picture', error: e);
      return null;
    }
  }

  Future<void> startVideoRecording() async {
    await state.maybeWhen(
      ready: (controller, isRecording, isFlashOn) async {
        if (!isRecording) {
          try {
            await controller.startVideoRecording();
            state = CameraState.ready(
              controller: controller,
              isRecording: true,
              isFlashOn: isFlashOn,
            );
          } catch (e) {
            Logger.log('Error starting video recording', error: e);
            state = CameraState.error(message: 'Error starting video recording: $e');
          }
        }
      },
      orElse: () {},
    );
  }

  Future<XFile?> stopVideoRecording() async {
    return await state.maybeWhen(
      ready: (controller, isRecording, isFlashOn) async {
        if (isRecording) {
          try {
            final videoFile = await controller.stopVideoRecording();
            state = CameraState.ready(
              controller: controller,
              isFlashOn: isFlashOn,
            );

            final mimeType = lookupMimeType(videoFile.path);

            if (mimeType == null) {
              final path = await FileSaver.instance.saveFile(
                name: videoFile.name,
                filePath: videoFile.path,
                ext: '.mp4',
              );

              return XFile(path, mimeType: 'video/mp4');
            }

            return videoFile;
          } catch (e) {
            Logger.log('Error stopping video recording', error: e);
            state = CameraState.error(message: 'Error stopping video recording: $e');
            return null;
          }
        }
        return null;
      },
      orElse: () => null,
    );
  }

  Future<void> _disposeCamera() async {
    if (_cameraController != null) {
      await _cameraController?.dispose();
      _cameraController = null;
    }
  }
}
