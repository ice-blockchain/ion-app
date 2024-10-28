// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_provider.g.dart';

@riverpod
class CameraControllerNotifier extends _$CameraControllerNotifier {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  CameraDescription? _frontCamera;
  CameraDescription? _backCamera;

  @override
  Future<Raw<CameraController>?> build() async {
    ref
      ..onDispose(() {
        _cameraController?.dispose();
      })
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
      return null;
    }

    return _initializeCamera();
  }

  Future<Raw<CameraController>?> _initializeCamera() async {
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
      return null;
    }

    return _createCameraController(initialCamera);
  }

  Future<Raw<CameraController>?> _createCameraController(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );

    try {
      await _cameraController?.initialize();
      _cameraController?.addListener(ref.notifyListeners);
      return _cameraController;
    } catch (e) {
      Logger.log('Camera initialization error: $e');

      _cameraController?.removeListener(ref.notifyListeners);
      await _cameraController?.dispose();
      _cameraController = null;
      return null;
    }
  }

  Future<void> pauseCamera() async {
    if (_cameraController != null) {
      _cameraController?.removeListener(ref.notifyListeners);
      await _cameraController?.dispose();
      _cameraController = null;
      state = const AsyncValue.data(null);
    }
  }

  Future<bool> resumeCamera() async {
    final hasPermission = ref.read(hasPermissionProvider(Permission.camera));

    if (!hasPermission) {
      return false;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _initializeCamera();
    });
    return state.value != null;
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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _createCameraController(newCamera);
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (_cameraController?.value.isInitialized ?? false) {
      try {
        await _cameraController?.setFlashMode(mode);
        ref.notifyListeners();
      } catch (e) {
        Logger.log('Error setting flash mode: $e');
      }
    }
  }

  Future<void> startVideoRecording() async {
    if (_cameraController?.value.isInitialized ?? false) {
      try {
        await _cameraController?.startVideoRecording();
        ref.notifyListeners();
      } catch (e) {
        Logger.log('Error starting video recording: $e');
      }
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (_cameraController?.value.isRecordingVideo ?? false) {
      try {
        final file = await _cameraController?.stopVideoRecording();
        ref.notifyListeners();
        return file;
      } catch (e) {
        Logger.log('Error stopping video recording: $e');
      }
    }
    return null;
  }
}
