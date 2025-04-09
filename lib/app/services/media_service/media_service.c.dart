// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_service.c.freezed.dart';
part 'media_service.c.g.dart';

@freezed
class MediaFile with _$MediaFile {
  const factory MediaFile({
    required String path,
    int? size,
    String? name,
    int? width,
    int? height,
    String? mimeType,
    String? thumb,
    String? blurhash,
    int? duration,
  }) = _MediaFile;

  const MediaFile._();

  factory MediaFile.fromJson(Map<String, dynamic> json) => _$MediaFileFromJson(json);

  String get basename => p.basename(path);
}

typedef CropImageUiSettings = List<PlatformUiSettings>;

class MediaService {
  Future<void> presentLimitedGallery(RequestType type) async {
    return PhotoManager.presentLimited(type: type);
  }

  Future<List<MediaFile>> fetchGalleryMedia({
    required int page,
    required int size,
    required MediaPickerType type,
  }) async {
    try {
      final albums = await PhotoManager.getAssetPathList(
        type: type.toRequestType(),
      );

      if (albums.isEmpty) return [];

      final assets = await albums.first.getAssetListPaged(
        page: page,
        size: size,
      );

      final mediaFiles = await Future.wait(
        assets.map((asset) async {
          final mimeType = await asset.mimeTypeAsync;

          return MediaFile(
            path: asset.id,
            height: asset.height,
            width: asset.width,
            mimeType: mimeType,
            duration: asset.duration,
          );
        }),
      );

      return mediaFiles;
    } catch (e) {
      Logger.log('Error fetching gallery images: $e');
      return [];
    }
  }

  Stream<List<MediaFile>> watchGalleryMedia({
    required int page,
    required int size,
    required MediaPickerType type,
  }) {
    final streamController = StreamController<List<MediaFile>>();

    Future<void> onChangeCallback(MethodCall _) async {
      final newMedia = await fetchGalleryMedia(
        page: page,
        size: size,
        type: type,
      );
      streamController.add(newMedia);
    }

    PhotoManager.addChangeCallback(onChangeCallback);
    PhotoManager.startChangeNotify();

    streamController.onCancel = () {
      PhotoManager.removeChangeCallback(onChangeCallback);
      PhotoManager.stopChangeNotify();
    };

    fetchGalleryMedia(
      page: page,
      size: size,
      type: type,
    ).then(streamController.add);

    return streamController.stream;
  }

  Future<MediaFile?> cropImage({
    required String path,
    required CropImageUiSettings uiSettings,
    CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
  }) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatio: aspectRatio,
      uiSettings: uiSettings,
    );

    if (croppedFile == null) return null;

    return MediaFile(path: croppedFile.path);
  }

  CropImageUiSettings buildCropImageUiSettings(
    BuildContext context, {
    CropStyle cropStyle = CropStyle.rectangle,
    List<CropAspectRatioPresetData> aspectRatioPresets = const [CropAspectRatioPreset.square],
  }) {
    return [
      AndroidUiSettings(
        toolbarTitle: context.i18n.common_crop_image,
        toolbarColor: context.theme.appColors.primaryAccent,
        toolbarWidgetColor: context.theme.appColors.primaryBackground,
        cropStyle: cropStyle,
        aspectRatioPresets: aspectRatioPresets,
      ),
      IOSUiSettings(
        title: context.i18n.common_crop_image,
        cropStyle: cropStyle,
        aspectRatioPresets: aspectRatioPresets,
      ),
      // `WebUiSettings` is required for Web, `context` is also required
      WebUiSettings(context: context),
    ];
  }

  Future<MediaFile?> saveImageToGallery(File imageFile) async {
    final asset = await PhotoManager.editor.saveImageWithPath(
      imageFile.path,
      title: 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final file = await asset.file;

    if (file == null) return null;

    final mimeType = await asset.mimeTypeAsync;

    return MediaFile(
      path: asset.id,
      height: asset.height,
      width: asset.width,
      mimeType: mimeType,
    );
  }

  Future<MediaFile?> saveVideoToGallery(String videoPath) async {
    final videoFile = File(videoPath);

    final asset = await PhotoManager.editor.saveVideo(
      videoFile,
      title: 'Camera_${DateTime.now().millisecondsSinceEpoch}',
    );

    final file = await asset.file;

    if (file == null) return null;

    final mimeType = await asset.mimeTypeAsync;

    return MediaFile(
      path: asset.id,
      mimeType: mimeType,
    );
  }

  Future<({Uint8List imageBytes, Offset position, Size size})?> captureWidgetAsImage(
    RenderObject renderObject,
  ) async {
    try {
      if (renderObject is RenderRepaintBoundary) {
        final image = renderObject.toImageSync(pixelRatio: 3);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          final imageBytes = byteData.buffer.asUint8List();
          final box = renderObject as RenderBox;
          final position = box.localToGlobal(Offset.zero);
          final size = box.size;
          return (imageBytes: imageBytes, position: position, size: size);
        }
      }
      return null;
    } catch (e, st) {
      Logger.log('Error capturing widget as image:', error: e, stackTrace: st);
      return null;
    }
  }

  // Convert all asset media id-s returned from MediaPicker to actual file path-es
  Future<List<MediaFile>> convertAssetIdsToMediaFiles(
    WidgetRef ref, {
    required List<MediaFile> mediaFiles,
  }) async {
    return Future.wait(
      mediaFiles.map((mediaFile) async {
        final assetEntity = await ref.read(assetEntityProvider(mediaFile.path).future);
        if (assetEntity == null) {
          throw AssetEntityFileNotFoundException();
        }
        final (mimeType, file) = await (assetEntity.mimeTypeAsync, assetEntity.file).wait;
        if (file == null) {
          throw AssetEntityFileNotFoundException();
        }
        return MediaFile(
          path: file.path,
          height: assetEntity.height,
          width: assetEntity.width,
          mimeType: mimeType,
          thumb: mediaFile.thumb,
          duration: assetEntity.duration,
        );
      }),
    );
  }

  Future<File?> getFileFromAppDirectory(String filename) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final file = File('${appDirectory.path}/$filename');
    if (!file.existsSync()) return null;

    return file;
  }
}

@riverpod
MediaService mediaService(Ref ref) => MediaService();
