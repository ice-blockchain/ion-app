import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:ice/app/features/camera/providers/gallery_images_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'thumbnail_data_provider.g.dart';

@riverpod
Future<Uint8List?> thumbnailData(ThumbnailDataRef ref, String assetId) async {
  final galleryState = ref.read(galleryImagesNotifierProvider).value;

  if (galleryState == null) return null;

  final imageData = galleryState.images.firstWhereOrNull((img) => img.asset.id == assetId);
  final asset = imageData?.asset;

  if (asset == null) return null;

  const int thumbnailWidth = 500;
  const int thumbnailHeight = 500;

  return asset.thumbnailDataWithSize(
    ThumbnailSize(thumbnailWidth, thumbnailHeight),
  );
}
