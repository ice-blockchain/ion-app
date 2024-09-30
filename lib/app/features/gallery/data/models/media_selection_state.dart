// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/services/media_service/media_service.dart';

part 'media_selection_state.freezed.dart';

@Freezed(copyWith: true, equal: true)
class MediaSelectionState with _$MediaSelectionState {
  const factory MediaSelectionState({
    required List<MediaFile> selectedMedia,
  }) = _MediaSelectionState;
}
