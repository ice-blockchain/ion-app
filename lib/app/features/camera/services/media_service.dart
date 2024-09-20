import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:ice/app/features/camera/utils/media_utils.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  const MediaService(this._picker, this._cameraController);

  final ImagePicker _picker;
  final CameraController _cameraController;

  Future<ImageData?> captureImageFromSystemCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return await saveCameraImage(File(image.path));
    }
    return null;
  }

  Future<List<ImageData>> fetchGalleryImages({required int page, required int size}) async {
    return await MediaUtils.fetchGalleryImages(page: page, size: size);
  }

  Future<ImageData?> saveCameraImage(File imageFile) async {
    return await MediaUtils.saveCameraImage(imageFile);
  }

  Future<ImageData?> captureImageFromCamera() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }

    try {
      final xFile = await _cameraController.takePicture();
      return await saveCameraImage(File(xFile.path));
    } catch (e) {
      log('Error capturing image: $e');
      return null;
    }
  }

  Future<ImageData?> pickImageFromGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return await saveCameraImage(File(image.path));
    }
    return null;
  }

  Future<ImageData?> pickImageFromCamera() async {
    return await captureImageFromCamera();
  }
}
