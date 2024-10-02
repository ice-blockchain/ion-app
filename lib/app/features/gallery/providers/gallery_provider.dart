// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/app/features/gallery/data/models/gallery_state.dart';
import 'package:ice/app/features/gallery/data/models/models.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:ice/app/services/logger/logger.dart';
import 'package:ice/app/services/media_service/media_service.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_provider.g.dart';

@riverpod
CacheManager cacheManager(CacheManagerRef ref) {
  return DefaultCacheManager();
}

@riverpod
Future<File?> cachedFile(CachedFileRef ref, String path) async {
  final cacheManager = ref.watch(cacheManagerProvider);
  try {
    final fileInfo = await cacheManager.getFileFromCache(path);
    if (fileInfo != null) {
      return fileInfo.file;
    }
    return await cacheManager.getSingleFile(path);
  } catch (e) {
    return null;
  }
}

@riverpod
Future<AssetEntity?> assetEntity(AssetEntityRef ref, String id) {
  return AssetEntity.fromId(id);
}

@riverpod
class GalleryNotifier extends _$GalleryNotifier {
  static const int _pageSize = 100;

  @override
  Future<GalleryState> build() async {
    final mediaService = ref.watch(mediaServiceProvider);
    final permissionsNotifier = ref.watch(permissionsProvider.notifier);

    // await permissionsNotifier.checkPermission(AppPermissionType.photos);

    // if (!permissionsNotifier.hasPermission(AppPermissionType.photos)) {
    //   await permissionsNotifier.requestPermission(AppPermissionType.photos);
    // }

    if (!permissionsNotifier.hasPermission(AppPermissionType.photos)) {
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
    final permissionsNotifier = ref.read(permissionsProvider.notifier);

    // if (!permissionsNotifier.hasPermission(AppPermissionType.camera)) {
    //   await permissionsNotifier.requestPermission(AppPermissionType.camera);

    if (!permissionsNotifier.hasPermission(AppPermissionType.camera)) {
      Logger.log('Camera Permission denied');
      return;
    }
    // }

    final mediaService = ref.read(mediaServiceProvider);
    final mediaSelectionNotifier = ref.read(mediaSelectionNotifierProvider.notifier);

    final mediaFile = await mediaService.captureImageFromCamera(saveToGallery: true);

    if (mediaFile != null) {
      ref.invalidateSelf();
      mediaSelectionNotifier.toggleSelection(mediaFile.path);
    }
  }
}
