import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'thumbnail_data_provider.g.dart';

@riverpod
Future<Uint8List?> thumbnailData(ThumbnailDataRef ref, String assetId) async {
  final asset = await AssetEntity.fromId(assetId);
  if (asset == null) {
    return null;
  }

  return asset.thumbnailDataWithSize(
    const ThumbnailSize(500, 500),
  );
}
