import 'dart:developer';

import 'package:ice/app/features/camera/data/models/gallery_images_state.dart';
import 'package:ice/app/features/camera/providers/media_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_images_provider.g.dart';

@riverpod
class GalleryImagesNotifier extends _$GalleryImagesNotifier {
  static const int _pageSize = 100;

  @override
  Future<GalleryImagesState> build() async {
    try {
      final mediaService = ref.watch(mediaServiceProvider);

      final images = await mediaService.fetchGalleryImages(page: 0, size: _pageSize);
      final hasMore = images.length == _pageSize;

      return GalleryImagesState(
        images: images,
        currentPage: 1,
        hasMore: hasMore,
      );
    } catch (e) {
      log('Error in GalleryImagesNotifier build: $e');
      return GalleryImagesState(
        images: [],
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

      final newImages = await mediaService.fetchGalleryImages(
        page: currentState.currentPage,
        size: _pageSize,
      );

      final hasMore = newImages.length == _pageSize;

      return currentState.copyWith(
        images: [...currentState.images, ...newImages],
        currentPage: currentState.currentPage + 1,
        hasMore: hasMore,
      );
    });
  }

  Future<void> reset() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final mediaService = ref.read(mediaServiceProvider);

      final newImages = await mediaService.fetchGalleryImages(page: 0, size: _pageSize);
      final hasMore = newImages.length == _pageSize;

      return GalleryImagesState(
        images: newImages,
        currentPage: 1,
        hasMore: hasMore,
      );
    });
  }
}
