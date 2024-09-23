import 'dart:developer';

import 'package:ice/app/features/gallery/data/models/gallery_media_state.dart';
import 'package:ice/app/features/gallery/providers/media_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_media_provider.g.dart';

@riverpod
class GalleryMediaNotifier extends _$GalleryMediaNotifier {
  static const int _pageSize = 100;

  @override
  Future<GalleryMediaState> build() async {
    try {
      final mediaService = ref.watch(mediaServiceProvider);

      final mediaData = await mediaService.fetchGalleryMedia(page: 0, size: _pageSize);
      final hasMore = mediaData.length == _pageSize;

      return GalleryMediaState(
        mediaData: mediaData,
        currentPage: 1,
        hasMore: hasMore,
      );
    } catch (e) {
      log('Error in GalleryImagesNotifier build: $e');
      return GalleryMediaState(
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

      return GalleryMediaState(
        mediaData: newMedia,
        currentPage: 1,
        hasMore: hasMore,
      );
    });
  }
}
