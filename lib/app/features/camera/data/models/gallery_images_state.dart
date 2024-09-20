import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/camera/data/models/image_data.dart';

part 'gallery_images_state.freezed.dart';

@Freezed(copyWith: true)
class GalleryImagesState with _$GalleryImagesState {
  const factory GalleryImagesState({
    required List<ImageData> images,
    required int currentPage,
    required bool hasMore,
  }) = _GalleryImagesState;
}
