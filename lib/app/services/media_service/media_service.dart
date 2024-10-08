// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/services/logger/logger.dart';
import 'package:image/image.dart' as img;
import 'package:image_compression_flutter/image_compression_flutter.dart' as compressor_package;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_service.freezed.dart';
part 'media_service.g.dart';

@Freezed(copyWith: true, equal: true)
class MediaFile with _$MediaFile {
  const factory MediaFile({
    required String path,
    int? width,
    int? height,
    String? mimeType,
  }) = _MediaFile;
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

  Future<XFile> compressImage(
    XFile file, {
    required int quality,
    required Size size,
    bool keepAspectRatio = true,
  }) async {
    try {
      final Uint8List resizedBytes;

      if (kIsWeb) {
        resizedBytes = await resizeImage(file, size, keepAspectRatio: keepAspectRatio);
      } else {
        resizedBytes = await Isolate.run<Uint8List>(() async {
          return resizeImage(file, size, keepAspectRatio: keepAspectRatio);
        });
      }

      if (resizedBytes.isEmpty) {
        throw Exception('Failed to resize image.');
      }

      final config = compressor_package.ImageFileConfiguration(
        input: compressor_package.ImageFile(
          filePath: '', // File path left empty since we're using rawBytes
          rawBytes: resizedBytes,
        ),
        config: compressor_package.Configuration(
          quality: quality,
        ),
      );

      final output = await compressor_package.compressor.compress(config);

      return XFile.fromData(output.rawBytes, name: file.name, mimeType: file.mimeType);
    } catch (e) {
      Logger.log('Error during image compression: $e');
      rethrow;
    }
  }

  Future<Uint8List> resizeImage(XFile file, Size size, {bool keepAspectRatio = true}) async {
    final originalBytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(originalBytes);

    if (decodedImage == null) {
      throw Exception('Failed to decode image.');
    }

    final resizedImage = img.copyResize(
      decodedImage,
      width: size.width.toInt(),
      height: size.height.toInt(),
      maintainAspect: keepAspectRatio,
    );

    return Uint8List.fromList(img.encodePng(resizedImage));
  }
}

@riverpod
MediaService mediaService(MediaServiceRef ref) => MediaService();
