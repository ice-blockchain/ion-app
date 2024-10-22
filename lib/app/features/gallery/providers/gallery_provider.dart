// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.dart';
import 'package:ion/app/features/gallery/data/models/gallery_state.dart';
import 'package:ion/app/features/gallery/data/models/models.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_provider.g.dart';

@riverpod
Future<AssetEntity?> assetEntity(Ref ref, String id) {
  return AssetEntity.fromId(id);
}

@riverpod
class GalleryNotifier extends _$GalleryNotifier {
  static const int _pageSize = 100;

  @override
  Future<GalleryState> build() async {
    final mediaService = ref.watch(mediaServiceProvider);

    final hasPermission = ref.read(hasPermissionProvider(Permission.photos));

    if (!hasPermission) {
      Logger.log('Photos Permission denied');
      return const GalleryState(
        mediaData: [],
        currentPage: 0,
        hasMore: false,
      );
    }

    final mediaData = await mediaService.fetchGalleryMedia(page: 0, size: _pageSize);
    final hasMore = mediaData.length == _pageSize;

    return GalleryState(
      mediaData: mediaData,
      currentPage: 1,
      hasMore: hasMore,
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
      );

      final hasMore = newMedia.length == _pageSize;

      return currentState.copyWith(
        mediaData: [...currentState.mediaData, ...newMedia],
        currentPage: currentState.currentPage + 1,
        hasMore: hasMore,
      );
    });
  }

  Future<void> captureImage() async {
    final mediaService = ref.read(mediaServiceProvider);
    final mediaSelectionNotifier = ref.read(mediaSelectionNotifierProvider.notifier);

    final mediaFile = await mediaService.captureImageFromCamera(saveToGallery: true);

    if (mediaFile != null) {
      state = await AsyncValue.guard(() async {
        final currentState = state.value!;
        final updatedMediaData = [mediaFile, ...currentState.mediaData];

        return currentState.copyWith(
          mediaData: updatedMediaData,
          currentPage: currentState.currentPage,
          hasMore: currentState.hasMore,
        );
      });

      mediaSelectionNotifier.toggleSelection(mediaFile.path);
    }
  }
}
