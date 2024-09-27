import 'package:ice/app/features/gallery/data/models/gallery_state.dart';
import 'package:ice/app/features/gallery/data/models/media_data.dart';
import 'package:ice/app/features/gallery/providers/providers.dart';
import 'package:ice/app/services/logger/logger.dart';
import 'package:ice/app/services/media/media.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_provider.g.dart';

@riverpod
class GalleryNotifier extends _$GalleryNotifier {
  static const int _pageSize = 100;

  @override
  Future<GalleryState> build() async {
    final mediaData = await _fetchGalleryMedia(page: 0, size: _pageSize);
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
      final newMedia = await _fetchGalleryMedia(
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
      final newMedia = await _fetchGalleryMedia(page: 0, size: _pageSize);
      final hasMore = newMedia.length == _pageSize;

      return GalleryState(
        mediaData: newMedia,
        currentPage: 1,
        hasMore: hasMore,
      );
    });
  }

  Future<void> captureImage() async {
    final mediaSelectionNotifier = ref.read(mediaSelectionNotifierProvider.notifier);

    final mediaFile = await MediaService.captureImageFromCamera(saveToGallery: true);

    if (mediaFile != null) {
      await refresh();
      mediaSelectionNotifier.toggleSelection(mediaFile.path);
    }
  }

  // TODO: move to MediaService, use List<MediaFile> as return value
  // TODO: do not use photo_manager lib outside of the MediaService
  // TODO: handle permissions with permissionsProvider
  Future<List<MediaData>> _fetchGalleryMedia({required int page, required int size}) async {
    try {
      final permission = await PhotoManager.requestPermissionExtend();

      if (!permission.isAuth) {
        await PhotoManager.openSetting();
        return [];
      }

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
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
        );
      }).toList();

      return images;
    } catch (e) {
      Logger.log('Error fetching gallery images: $e');
      return [];
    }
  }
}
