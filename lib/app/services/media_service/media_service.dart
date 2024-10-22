// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_service.freezed.dart';
part 'media_service.g.dart';

@freezed
class MediaFile with _$MediaFile {
  const factory MediaFile({
    required String path,
    int? size,
    String? name,
    int? width,
    int? height,
    String? mimeType,
  }) = _MediaFile;

  factory MediaFile.fromJson(Map<String, dynamic> json) => _$MediaFileFromJson(json);
}

class MediaService {
  Future<MediaFile?> captureImageFromCamera({bool saveToGallery = false}) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return null;

    if (!saveToGallery) {
      return MediaFile(path: image.path, mimeType: image.mimeType);
    }

    return _saveCameraImage(File(image.path));
  }

  Future<List<MediaFile>> fetchGalleryMedia({required int page, required int size}) async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isEmpty) return [];

      final assets = await albums.first.getAssetListPaged(
        page: page,
        size: size,
      );

      final mediaFiles = assets.map((AssetEntity asset) {
        return MediaFile(
          path: asset.id,
          height: asset.height,
          width: asset.width,
          mimeType: asset.mimeType,
        );
      }).toList();

      return mediaFiles;
    } catch (e) {
      Logger.log('Error fetching gallery images: $e');
      return [];
    }
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
      title: 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    if (asset == null) return null;

    final file = await asset.file;

    if (file == null) return null;

    return MediaFile(
      path: asset.id,
      height: asset.height,
      width: asset.width,
      mimeType: asset.mimeType,
    );
  }

  Future<MediaFile?> saveVideoToGallery(String videoPath) async {
    final videoFile = File(videoPath);

    final asset = await PhotoManager.editor.saveVideo(
      videoFile,
      title: 'Camera_${DateTime.now().millisecondsSinceEpoch}',
    );

    if (asset == null) return null;

    final file = await asset.file;

    if (file == null) return null;

    return MediaFile(
      path: asset.id,
      mimeType: asset.mimeType,
    );
  }

  Future<File?> selectVideoFromGallery() async {
    final results = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (results != null) {
      return File(results.path);
    }

    return null;
  }
}

@riverpod
MediaService mediaService(Ref ref) => MediaService();
