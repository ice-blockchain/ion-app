// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/gallery/data/models/media_data.dart';

part 'gallery_state.freezed.dart';

@Freezed(copyWith: true, equal: true)
class GalleryState with _$GalleryState {
  const factory GalleryState({
    required List<MediaData> mediaData,
    required int currentPage,
    required bool hasMore,
  }) = _GalleryState;
}
