import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/gallery/data/models/media_data.dart';

part 'gallery_media_state.freezed.dart';

@Freezed(copyWith: true, equal: true)
class GalleryMediaState with _$GalleryMediaState {
  const factory GalleryMediaState({
    required List<MediaData> mediaData,
    required int currentPage,
    required bool hasMore,
  }) = _GalleryMediaState;
}
