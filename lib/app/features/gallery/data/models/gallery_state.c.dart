// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/gallery/data/models/album_data.c.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

part 'gallery_state.c.freezed.dart';

@freezed
class GalleryState with _$GalleryState {
  const factory GalleryState({
    required List<MediaFile> mediaData,
    required int currentPage,
    required bool hasMore,
    required MediaPickerType type,
    AlbumData? selectedAlbum,
  }) = _GalleryState;
}
