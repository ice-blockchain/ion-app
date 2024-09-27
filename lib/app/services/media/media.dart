import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/services/logger/logger.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media.freezed.dart';

@freezed
class MediaFile with _$MediaFile {
  const factory MediaFile({
    required String path,
    int? width,
    int? height,
    String? mimeType,
  }) = _MediaFile;
}

class MediaService {
  MediaService._();

  static Future<MediaFile?> captureImageFromCamera({bool saveToGallery = false}) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return null;

    if (!saveToGallery) {
      return MediaFile(path: image.path, mimeType: image.mimeType);
    }

    return _saveCameraImage(File(image.path));
  }

  static Future<CroppedFile?> cropImage({
    required BuildContext context,
    required String path,
    CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
    List<CropAspectRatioPresetData> aspectRatioPresets = const [CropAspectRatioPreset.square],
  }) async {
    return ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: aspectRatio,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: context.i18n.common_crop_image,
          toolbarColor: context.theme.appColors.primaryAccent,
          toolbarWidgetColor: context.theme.appColors.primaryBackground,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: aspectRatioPresets,
        ),
        IOSUiSettings(
          title: context.i18n.common_crop_image,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: aspectRatioPresets,
        ),
        WebUiSettings(context: context),
      ],
    );
  }

  static Future<MediaFile?> _saveCameraImage(File imageFile) async {
    try {
      final asset = await PhotoManager.editor.saveImageWithPath(
        imageFile.path,
        title: 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      if (asset == null) return null;

      final file = await asset.file;

      if (file == null) return null;

      return MediaFile(
        path: file.path,
        height: asset.height,
        width: asset.width,
        mimeType: asset.mimeType,
      );
    } catch (e) {
      Logger.log('Error saving camera image: $e');
      rethrow;
    }
  }
}
