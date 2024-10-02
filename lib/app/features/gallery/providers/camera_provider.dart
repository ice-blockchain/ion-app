// SPDX-License-Identifier: ice License 1.0

import 'package:camera/camera.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
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

    return _initializeCamera();
  }

  Future<Raw<CameraController>?> _initializeCamera() async {
    final permissionsNotifier = ref.read(permissionsProvider.notifier);

    await permissionsNotifier.requestPermission(AppPermissionType.camera);

    if (!permissionsNotifier.hasPermission(AppPermissionType.camera)) {
      Logger.log('Camera Permission denied');
      return null;
    }

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
      await _cameraController!.initialize();
      _cameraController!.addListener(ref.notifyListeners);
      return _cameraController;
    } catch (e) {
      Logger.log('Camera initialization error: $e');
      await _cameraController!.dispose();
      _cameraController = null;
      return null;
    }
  }

  Future<void> pauseCamera() async {
    await _cameraController?.dispose();
    _cameraController = null;
    state = const AsyncValue.data(null);
  }

  Future<void> resumeCamera() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      final camera = await _initializeCamera();
      state = AsyncValue.data(camera);
    }
  }
}
