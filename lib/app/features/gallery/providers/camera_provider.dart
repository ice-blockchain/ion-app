import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_provider.g.dart';

@riverpod
Future<Raw<CameraController?>> cameraController(CameraControllerRef ref) async {
  final permissionStatus = await Permission.camera.status;
  if (!permissionStatus.isGranted) {
    final result = await Permission.camera.request();
    if (!result.isGranted) {
      log('Camera Permission denied');
      return null;
    }
  }

  final cameras = await availableCameras();
  if (cameras.isEmpty) {
    log('No available cameras.');
    return null;
  }

  final camera = cameras.first;

  final cameraController = CameraController(
    camera,
    ResolutionPreset.medium,
    enableAudio: false,
  );

  try {
    await cameraController.initialize();

    ref.onDispose(() => cameraController.dispose());

    cameraController.addListener(() => ref.notifyListeners());
  } catch (e) {
    log('Camera initialization error: $e');
    cameraController.dispose();
  }

  return cameraController;
}

@riverpod
Future<void> captureImage(CaptureImageRef ref) async {
  final mediaService = ref.read(mediaServiceProvider);
  final mediaSelectionNotifier = ref.read(mediaSelectionNotifierProvider.notifier);

  final mediaData = await mediaService.captureImageFromCamera();

  if (mediaData != null) {
    await ref.read(galleryMediaNotifierProvider.notifier).refresh();
    mediaSelectionNotifier.toggleSelection(mediaData.asset.id);
  }
}
