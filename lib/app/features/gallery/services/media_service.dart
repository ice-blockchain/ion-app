import 'dart:developer';
import 'dart:io';

import 'package:ice/app/features/gallery/data/models/media_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaService {
  MediaService({required this.picker});

  final ImagePicker picker;

  Future<MediaData?> captureImageFromCamera() async {
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      return await _saveCameraImage(File(image.path));
    }

    return null;
  }

  Future<MediaData?> _saveCameraImage(File imageFile) async {
    try {
      final asset = await PhotoManager.editor.saveImageWithPath(
        imageFile.path,
        title: 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      if (asset != null) {
        return MediaData(
          asset: asset,
          order: 0,
          isFromCamera: true,
        );
      }
    } catch (e) {
      log('Error saving camera image: $e');
      return null;
    }
    return null;
  }

  Future<List<MediaData>> fetchGalleryMedia({required int page, required int size}) async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();

      if (!permission.isAuth) {
        await PhotoManager.openSetting();
        return [];
      }

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );

      if (albums.isEmpty) return [];

      final assets = await albums.first.getAssetListPaged(
        page: page,
        size: size,
      );

      final images = assets.map((asset) {
        return MediaData(
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
}
