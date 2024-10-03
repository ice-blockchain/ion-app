// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/services/media_service/photo_compress_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_service.freezed.dart';
part 'media_service.g.dart';

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
  MediaService(this.photoCompressService);

  final IPhotoCompressService photoCompressService;

  Future<MediaFile?> captureImageFromCamera({bool saveToGallery = false}) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return null;

    final compressedImage = await photoCompressService.compressImage(
      image,
    );

    if (!saveToGallery) {
      return MediaFile(path: compressedImage.path, mimeType: compressedImage.mimeType);
    }

    return _saveCameraImage(File(image.path));
  }

  Future<MediaFile?> cropImage({
    required BuildContext context,
    required String path,
    CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
    List<CropAspectRatioPresetData> aspectRatioPresets = const [CropAspectRatioPreset.square],
  }) async {
    final croppedFile = await ImageCropper().cropImage(
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
        // `WebUiSettings` is required for Web, `context` is also required
        WebUiSettings(context: context),
      ],
    );

    if (croppedFile == null) return null;

    return MediaFile(path: croppedFile.path);
  }

  Future<MediaFile?> _saveCameraImage(File imageFile) async {
    final asset = await PhotoManager.editor.saveImageWithPath(
      imageFile.path,
      title: 'Camera_${DateTime.now().millisecondsSinceEpoch}',
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
  }
}

@riverpod
MediaService mediaService(MediaServiceRef ref) => MediaService(
      ref.read(photoCompressService),
    );
