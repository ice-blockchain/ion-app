// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/permissions/providers/permissions_provider.dart';
import 'package:ice/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_provider.g.dart';

@riverpod
class CameraControllerNotifier extends _$CameraControllerNotifier {
  CameraController? _cameraController;

  @override
  Future<Raw<CameraController>?> build() async {
    ref.onDispose(() {
      _cameraController?.dispose();
    });

    final hasPermission = ref.watch(hasPermissionProvider(Permission.camera));

    if (!hasPermission) {
      return null;
    }

    return _initializeCamera();
  }

  Future<Raw<CameraController>?> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      Logger.log('No available cameras.');
      return null;
    }

    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
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

    if (_cameraController == null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        return _initializeCamera();
      });
      return state.value != null;
    }
    return true;
  }

  Future<bool> handlePermissionChange({required bool hasPermission}) async {
    if (hasPermission) {
      return resumeCamera();
    } else {
      await pauseCamera();
      return false;
    }
  }

  Future<void> handleCameraLifecycleState(AppLifecycleState state) async {
    final hasPermission = ref.read(hasPermissionProvider(Permission.camera));

    if (state == AppLifecycleState.resumed && hasPermission) {
      await resumeCamera();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      await pauseCamera();
    }
  }
}
