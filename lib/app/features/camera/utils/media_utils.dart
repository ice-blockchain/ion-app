import 'dart:developer';
import 'dart:typed_data';

import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

class MediaUtils {
  static final Uuid _uuid = Uuid();

  static Future<List<ImageData>> fetchGalleryImages() async {
    try {
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend().timeout(const Duration(seconds: 10));

      if (!permission.isAuth) {
        await PhotoManager.openSetting();
        return [];
      }

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      ).timeout(const Duration(seconds: 10));

      if (albums.isEmpty) return [];

      AssetPathEntity album = albums.first;

      List<AssetEntity> assets =
          await album.getAssetListPaged(page: 0, size: 100).timeout(const Duration(seconds: 10));

      List<ImageData> images = [];
      for (var asset in assets) {
        try {
          Uint8List? thumbData = await asset
              .thumbnailDataWithSize(const ThumbnailSize(200, 200))
              .timeout(const Duration(seconds: 5));
          if (thumbData != null) {
            images.add(
              ImageData(
                id: _uuid.v4(),
                thumbData: thumbData,
                order: 0,
                isFromCamera: false,
              ),
            );
          }
        } catch (e) {
          log('Error while getting thumbnail for asset: $e');
        }
      }

      return images;
    } catch (e) {
      return [];
    }
  }

  static Future<ImageData?> saveCameraImage(XFile image) async {
    try {
      final AssetEntity? asset = await PhotoManager.editor
          .saveImageWithPath(
            image.path,
            title: 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
          )
          .timeout(const Duration(seconds: 10));

      if (asset != null) {
        Uint8List? thumbData = await asset
            .thumbnailDataWithSize(const ThumbnailSize(200, 200))
            .timeout(const Duration(seconds: 5));
        if (thumbData != null) {
          return ImageData(
            id: _uuid.v4(),
            thumbData: thumbData,
            order: 0,
            isFromCamera: true,
          );
        }
      }
    } catch (e) {
      log('Error while saving camera image: $e');
    }
    return null;
  }
}
