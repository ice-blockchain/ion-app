import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

String getAdaptiveImageUrl(String imageUrl, double imageWidth) {
  return '$imageUrl?width=${imageWidth.toInt()}';
}

Future<CroppedFile?> pickImageFromGallery() async {
  final XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 50,
  );
  return _cropImage(pickedFile?.path);
}

Future<CroppedFile?> takePhoto() async {
  final XFile? capturedFile = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 50,
  );
  return _cropImage(capturedFile?.path);
}

Future<CroppedFile?> _cropImage(String? path) async {
  if (path == null) return null;

  return await ImageCropper().cropImage(
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
