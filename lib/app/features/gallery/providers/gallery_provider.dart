import 'dart:developer';

import 'package:ice/app/features/gallery/data/models/gallery_state.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_provider.g.dart';

@riverpod
class GalleryNotifier extends _$GalleryNotifier {
  static const int _pageSize = 100;

  @override
  Future<GalleryState> build() async {
    try {
      final mediaService = ref.watch(mediaServiceProvider);

      final mediaData = await mediaService.fetchGalleryMedia(page: 0, size: _pageSize);
      final hasMore = mediaData.length == _pageSize;

      return GalleryState(
        mediaData: mediaData,
        currentPage: 1,
        hasMore: hasMore,
      );
    } catch (e) {
      log('Error in GalleryImagesNotifier build: $e');
      return GalleryState(
        mediaData: [],
        currentPage: 0,
        hasMore: false,
      );
    }
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

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final mediaService = ref.read(mediaServiceProvider);

      final newMedia = await mediaService.fetchGalleryMedia(page: 0, size: _pageSize);
      final hasMore = newMedia.length == _pageSize;

      return GalleryState(
        mediaData: newMedia,
        currentPage: 1,
        hasMore: hasMore,
      );
    });
  }

  Future<void> captureImage() async {
    final mediaService = ref.read(mediaServiceProvider);
    final mediaSelectionNotifier = ref.read(mediaSelectionNotifierProvider.notifier);

    final mediaData = await mediaService.captureImageFromCamera();

    if (mediaData != null) {
      await refresh();
      mediaSelectionNotifier.toggleSelection(mediaData.asset.id);
    }
  }
}
