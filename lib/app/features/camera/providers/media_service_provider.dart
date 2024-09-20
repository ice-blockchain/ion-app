import 'dart:developer';

import 'package:ice/app/features/camera/providers/camera_provider.dart';
import 'package:ice/app/features/camera/services/media_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_service_provider.g.dart';

@riverpod
ImagePicker imagePicker(ImagePickerRef ref) => ImagePicker();

@riverpod
MediaService? cameraMediaService(CameraMediaServiceRef ref) {
  final imagePicker = ref.watch(imagePickerProvider);
  final cameraControllerNotifier = ref.watch(cameraControllerProvider);
  final cameraController = cameraControllerNotifier.value;

  if (cameraController == null) {
    log('CameraController is not available.');
    return null;
  }

  return MediaService(imagePicker, cameraController);
}

@riverpod
int maxSelection(MaxSelectionRef ref) => 5;
