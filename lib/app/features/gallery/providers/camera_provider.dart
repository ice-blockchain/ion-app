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
  List<CameraDescription>? _cameras;

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
    _cameras = await availableCameras();
    if (_cameras!.isEmpty) {
      Logger.log('No available cameras.');
      return null;
    }

    final camera = _cameras!.first;

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

  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final currentIndex = _cameras!.indexOf(_cameraController!.description);
    final newIndex = (currentIndex + 1) % _cameras!.length;

    await pauseCamera();
    state = const AsyncValue.loading();

    _cameraController = CameraController(
      _cameras![newIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      _cameraController!.addListener(ref.notifyListeners);
      state = AsyncValue.data(_cameraController);
    } catch (e) {
      Logger.log('Camera switch error: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<XFile?> takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      Logger.log('Error: select a camera first.');
      return null;
    }

    try {
      final file = await _cameraController!.takePicture();
      return file;
    } catch (e) {
      Logger.log('Error taking picture: $e');
      return null;
    }
  }

  Future<void> startVideoRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      Logger.log('Error: select a camera first.');
      return;
    }

    try {
      await _cameraController!.startVideoRecording();
    } catch (e) {
      Logger.log('Error starting video recording: $e');
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo) {
      Logger.log('Error: no video recording in progress.');
      return null;
    }

    try {
      final file = await _cameraController!.stopVideoRecording();
      return file;
    } catch (e) {
      Logger.log('Error stopping video recording: $e');
      return null;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      Logger.log('Error: select a camera first.');
      return;
    }

    try {
      await _cameraController!.setFlashMode(mode);
    } catch (e) {
      Logger.log('Error setting flash mode: $e');
    }
  }
}
