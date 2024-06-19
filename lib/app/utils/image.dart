import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

String getAdaptiveImageUrl(String imageUrl, double imageWidth) {
  return '$imageUrl?width=${imageWidth.toInt()}';
}

const int pickerImageQuality = 50;

Future<CroppedFile?> pickImageFromGallery() async {
  final pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: pickerImageQuality,
  );
  return _cropImage(pickedFile?.path);
}

Future<CroppedFile?> takePhoto() async {
  final capturedFile = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: pickerImageQuality,
  );
  return _cropImage(capturedFile?.path);
}

Future<CroppedFile?> _cropImage(String? path) async {
  if (path == null) return null;

  return ImageCropper().cropImage(
    sourcePath: path,
    aspectRatioPresets: <CropAspectRatioPreset>[CropAspectRatioPreset.square],
    cropStyle: CropStyle.circle,
    uiSettings: <PlatformUiSettings>[
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Crop Image',
      ),
    ],
  );
}
