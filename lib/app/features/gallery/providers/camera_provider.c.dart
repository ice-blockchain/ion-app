// SPDX-License-Identifier: ice License 1.0

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/scheduler.dart';
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

      await _createCameraController(initialCamera);
    } catch (e) {
      Logger.log('Camera initialization error: $e');
      state = CameraState.error(message: 'Camera initialization error: $e');
    }
  }

  Future<void> _createCameraController(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.max,
    );

    try {
      await _cameraController?.initialize();
      _cameraController?.addListener(_onCameraControllerUpdate);

      final minZoomLevel = await _cameraController!.getMinZoomLevel();
      final maxZoomLevel = await _cameraController!.getMaxZoomLevel();

      state = CameraState.ready(
        controller: _cameraController!,
        minZoomLevel: minZoomLevel,
        maxZoomLevel: maxZoomLevel,
        currentZoomLevel: minZoomLevel,
      );
    } catch (e) {
      Logger.log('Camera initialization error: $e');
      await _disposeCamera();
      throw Exception('Camera initialization error: $e');
    }
  }

  Future<void> pauseCamera() async {
    if (_cameraController != null) {
      state = const CameraState.paused();

      Logger.log('Pausing camera - disposing controller');

      final controllerToDispose = _cameraController;
      controllerToDispose?.removeListener(_onCameraControllerUpdate);

      _cameraController = null;

      try {
        await controllerToDispose?.dispose();
        Logger.log('Camera controller disposed');
      } catch (e) {
        Logger.log('Error disposing camera controller', error: e);
      }
    }
  }

  Future<bool> resumeCamera() async {
    final hasPermission = ref.read(hasPermissionProvider(Permission.camera));
    if (!hasPermission) {
      Logger.log('Resume camera called without permission.');
      return false;
    }

    if (state is CameraLoading) {
      Logger.log('Camera already loading, skipping resume request');
      return false;
    }

    if (state is CameraReady && (_cameraController?.value.isInitialized ?? false)) {
      Logger.log('Camera already ready, no need to resume');
      return true;
    }

    Logger.log('Resuming camera with full initialization');
    await _initializeCamera();
    final isReady = state is CameraReady;
    Logger.log('Camera resume result: $isReady');
    return isReady;
  }

  Future<bool> handlePermissionChange({required bool hasPermission}) async {
    if (hasPermission) {
      return resumeCamera();
    } else {
      Logger.log('Camera permission denied. Disposing camera.');
      if (_cameraController != null) {
        _cameraController?.removeListener(_onCameraControllerUpdate);
        await _disposeCamera();
      }
      state = const CameraState.initial();
      return false;
    }
  }

  Future<void> switchCamera() async {
    if (_cameraController == null) {
      Logger.log('Switch camera called but no current controller.');
      await _initializeCamera();
      if (_cameraController == null) return;
    }

    final currentCamera = _cameraController!.description;
    final newCamera =
        currentCamera.lensDirection == CameraLensDirection.back ? _frontCamera : _backCamera;

    if (newCamera == null) {
      Logger.log('No other camera available to switch to.');
      return;
    }

    Logger.log('Switching camera. Disposing current controller.');
    _cameraController?.removeListener(_onCameraControllerUpdate);
    await _disposeCamera();

    state = const CameraState.loading();
    try {
      await _createCameraController(newCamera);
    } catch (e) {
      state = CameraState.error(message: 'Camera switch error: $e');
    }
  }

  Future<void> setZoomLevel(double zoom) async {
    await state.maybeWhen(
      ready: (
        controller,
        isRecording,
        isFlashOn,
        minZoomLevel,
        maxZoomLevel,
        currentZoomLevel,
      ) async {
        if (zoom >= minZoomLevel && zoom <= maxZoomLevel) {
          try {
            await controller.setZoomLevel(zoom);
            state = CameraState.ready(
              controller: controller,
              isRecording: isRecording,
              isFlashOn: isFlashOn,
              minZoomLevel: minZoomLevel,
              maxZoomLevel: maxZoomLevel,
              currentZoomLevel: zoom,
            );
          } catch (e) {
            Logger.log('Error setting zoom level', error: e);
            state = CameraState.error(message: 'Error setting zoom level: $e');
          }
        }
      },
      orElse: () {},
    );
  }

  Future<void> setFlashMode(FlashMode mode) async {
    await state.maybeWhen(
      ready: (
        controller,
        isRecording,
        isFlashOn,
        minZoomLevel,
        maxZoomLevel,
        currentZoomLevel,
      ) async {
        try {
          await controller.setFlashMode(mode);
          state = CameraState.ready(
            controller: controller,
            isRecording: isRecording,
            isFlashOn: mode == FlashMode.torch,
            minZoomLevel: minZoomLevel,
            maxZoomLevel: maxZoomLevel,
            currentZoomLevel: currentZoomLevel,
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
      ready: (
        controller,
        isRecording,
        isFlashOn,
        minZoomLevel,
        maxZoomLevel,
        currentZoomLevel,
      ) async {
        final newFlashMode = isFlashOn ? FlashMode.off : FlashMode.torch;
        try {
          await controller.setFlashMode(newFlashMode);
          state = CameraState.ready(
            controller: controller,
            isRecording: isRecording,
            isFlashOn: !isFlashOn,
            minZoomLevel: minZoomLevel,
            maxZoomLevel: maxZoomLevel,
            currentZoomLevel: currentZoomLevel,
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
      ready: (
        controller,
        isRecording,
        isFlashOn,
        minZoomLevel,
        maxZoomLevel,
        currentZoomLevel,
      ) async {
        if (!isRecording) {
          try {
            await controller.startVideoRecording();
            state = CameraState.ready(
              controller: controller,
              isRecording: true,
              isFlashOn: isFlashOn,
              minZoomLevel: minZoomLevel,
              maxZoomLevel: maxZoomLevel,
              currentZoomLevel: currentZoomLevel,
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
      ready: (
        controller,
        isRecording,
        isFlashOn,
        minZoomLevel,
        maxZoomLevel,
        currentZoomLevel,
      ) async {
        if (isRecording) {
          try {
            final videoFile = await controller.stopVideoRecording();
            state = CameraState.ready(
              controller: controller,
              isFlashOn: isFlashOn,
              minZoomLevel: minZoomLevel,
              maxZoomLevel: maxZoomLevel,
              currentZoomLevel: currentZoomLevel,
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
      try {
        await _cameraController?.dispose();
        Logger.log('Camera controller disposed in _disposeCamera');
      } catch (e) {
        Logger.log('Error disposing camera controller in _disposeCamera', error: e);
      } finally {
        _cameraController = null;
      }
    }
  }
}
