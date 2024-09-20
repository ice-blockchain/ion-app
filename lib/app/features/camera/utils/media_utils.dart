import 'dart:developer';
import 'dart:io';

import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

class MediaUtils {
  static final Uuid _uuid = Uuid();

  static Future<List<ImageData>> fetchGalleryImages({
    required int page,
    required int size,
  }) async {
    try {
      final PermissionState permission = await PhotoManager.requestPermissionExtend();

      if (!permission.isAuth) {
        await PhotoManager.openSetting();
        return [];
      }

      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );

      if (albums.isEmpty) return [];

      AssetPathEntity album = albums.first;

      List<AssetEntity> assets = await album.getAssetListPaged(
        page: page,
        size: size,
      );

      List<ImageData> images = assets.map((asset) {
        return ImageData(
          id: _uuid.v4(),
          asset: asset,
          order: 0,
          isFromCamera: false,
        );
      }).toList();

      return images;
    } catch (e) {
      log('Error fetching gallery images: $e');
      return [];
    }
  }

  static Future<ImageData?> saveCameraImage(File imageFile) async {
    try {
      final AssetEntity? asset = await PhotoManager.editor.saveImageWithPath(
        imageFile.path,
        title: 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      if (asset != null) {
        return ImageData(
          id: _uuid.v4(),
          asset: asset,
          order: 0,
          isFromCamera: true,
        );
      }
    } catch (e) {
      log('Error saving camera image: $e');
      throw e;
    }
    return null;
  }
}
