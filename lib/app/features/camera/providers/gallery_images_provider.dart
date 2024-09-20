import 'package:ice/app/features/camera/data/models/gallery_images_state.dart';
import 'package:ice/app/features/camera/utils/media_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gallery_images_provider.g.dart';

@riverpod
class GalleryImagesNotifier extends _$GalleryImagesNotifier {
  static const int _pageSize = 100;

  @override
  FutureOr<GalleryImagesState> build() async => await _fetchImages(0);

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.value?.hasMore == false) return;

    final currentState = state.value;
    if (currentState == null) return;

    state = await AsyncValue.guard(() => _fetchImages(currentState.currentPage));
  }

  Future<void> reset() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchImages(0));
  }

  Future<GalleryImagesState> _fetchImages(int page) async {
    final newImages = await MediaUtils.fetchGalleryImages(
      page: page,
      size: _pageSize,
    );

    final hasMore = newImages.length == _pageSize;

    final currentState = state.valueOrNull ??
        GalleryImagesState(
          images: [],
          currentPage: 0,
          hasMore: true,
        );

    return currentState.copyWith(
      images: page == 0 ? newImages : [...currentState.images, ...newImages],
      currentPage: page + 1,
      hasMore: hasMore,
    );
  }
}
