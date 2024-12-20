// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/features/gallery/data/models/gallery_state.c.dart';
import 'package:ion/app/features/gallery/data/models/models.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_provider.c.g.dart';

@riverpod
Future<AssetEntity?> assetEntity(Ref ref, String id) {
  return AssetEntity.fromId(id);
}

@riverpod
Future<AssetEntity?> latestGalleryPreview(Ref ref) async {
  final mediaService = ref.watch(mediaServiceProvider);
  final mediaData = await mediaService.fetchGalleryMedia(
    page: 0,
    size: 1,
    type: MediaPickerType.image,
  );

  return await ref.watch(assetEntityProvider(mediaData.first.path).future);
}

@riverpod
Future<String?> assetFilePath(Ref ref, String assetId) async {
  final assetEntity = await ref.watch(assetEntityProvider(assetId).future);

  if (assetEntity == null) return null;

  final file = await assetEntity.file;

  return file?.path;
}

@riverpod
class GalleryNotifier extends _$GalleryNotifier {
  static const int _pageSize = 100;

  @override
  Future<GalleryState> build({MediaPickerType type = MediaPickerType.common}) async {
    final mediaService = ref.watch(mediaServiceProvider);
    final hasPermission = ref.read(hasPermissionProvider(Permission.photos));

    if (!hasPermission) {
      Logger.log('Photos Permission denied');
      return GalleryState(
        mediaData: [],
        currentPage: 0,
        hasMore: false,
        type: type,
      );
    }

    final mediaData = await mediaService.fetchGalleryMedia(
      page: 0,
      size: _pageSize,
      type: type,
    );

    final hasMore = mediaData.length == _pageSize;

    return GalleryState(
      mediaData: mediaData,
      currentPage: 1,
      hasMore: hasMore,
      type: type,
    );
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.value?.hasMore == false) return;

    final currentState = state.value;
    if (currentState == null) return;

    state = await AsyncValue.guard(() async {
      final mediaService = ref.read(mediaServiceProvider);
      final newMedia = await mediaService.fetchGalleryMedia(
        page: currentState.currentPage,
        size: _pageSize,
        type: currentState.type,
      );

      final hasMore = newMedia.length == _pageSize;

      return currentState.copyWith(
        mediaData: [...currentState.mediaData, ...newMedia],
        currentPage: currentState.currentPage + 1,
        hasMore: hasMore,
      );
    });
  }

  Future<void> addCapturedMediaFileToGallery(MediaFile mediaFile) async {
    state = await AsyncValue.guard(() async {
      final currentState = state.value!;
      final updatedMediaData = [mediaFile, ...currentState.mediaData];

      return currentState.copyWith(
        mediaData: updatedMediaData,
        currentPage: currentState.currentPage,
        hasMore: currentState.hasMore,
      );
    });

    final currentState = state.value;
    if (currentState == null) return;

    ref.read(mediaSelectionNotifierProvider.notifier).toggleSelection(
          mediaFile.path,
          type: currentState.type,
        );
  }
}
