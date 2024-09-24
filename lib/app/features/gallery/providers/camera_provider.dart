import 'package:camera/camera.dart';
import 'package:ice/app/services/logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_provider.g.dart';

@riverpod
Future<Raw<CameraController?>> cameraController(CameraControllerRef ref) async {
  final permissionStatus = await Permission.camera.status;
  if (!permissionStatus.isGranted) {
    final result = await Permission.camera.request();
    if (!result.isGranted) {
      Logger.log('Camera Permission denied');
      return null;
    }
  }

  final cameras = await availableCameras();
  if (cameras.isEmpty) {
    Logger.log('No available cameras.');
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
    Logger.log('Camera initialization error: $e');
    cameraController.dispose();
  }

  return cameraController;
}
