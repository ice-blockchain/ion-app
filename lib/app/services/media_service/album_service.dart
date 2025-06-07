// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/gallery/data/models/album_data.c.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumService {
  final Map<String, AssetPathEntity> _albumsCache = {};

  AssetPathEntity? getAssetPathEntityById(String albumId) => _albumsCache[albumId];

  Future<AssetEntity?> fetchFirstAssetOfAlbum(String albumId) async {
    final pathEntity = _albumsCache[albumId];
    if (pathEntity == null) return null;

    final assets = await pathEntity.getAssetListRange(start: 0, end: 1);
    if (assets.isEmpty) return null;

    return assets.first;
  }

  Future<List<AlbumData>> fetchAlbums({required MediaPickerType type}) async {
    final assetPathList = await PhotoManager.getAssetPathList(
      type: type.toRequestType(),
    );

    _albumsCache.clear();

    final futures = assetPathList.map((ap) async {
      _albumsCache[ap.id] = ap;
      final count = await ap.assetCountAsync;
      return AlbumData(
        id: ap.id,
        name: ap.name,
        assetCount: count,
        isAll: ap.isAll,
      );
    }).toList();

    return Future.wait(futures);
  }

  Future<List<MediaFile>> fetchMediaFromAlbum({
    required String albumId,
    required int page,
    required int size,
  }) async {
    final assetPath = _albumsCache[albumId];
    if (assetPath == null) {
      Logger.log('Album not found in cache: $albumId');
      return [];
    }

    final assets = await assetPath.getAssetListPaged(
      page: page,
      size: size,
    );

    final mediaFiles = <MediaFile>[];

    for (final asset in assets) {
      final mimeType = await asset.mimeTypeAsync;
      mediaFiles.add(
        MediaFile(
          path: asset.id,
          height: asset.height,
          width: asset.width,
          mimeType: mimeType,
        ),
      );
    }

    return mediaFiles;
  }
}
