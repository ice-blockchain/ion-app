// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

part 'media_selection_state.c.freezed.dart';

@freezed
class MediaSelectionState with _$MediaSelectionState {
  const factory MediaSelectionState({
    required List<MediaFile> selectedMedia,
    required int maxSelection,
    int? maxVideoDurationInSeconds,
  }) = _MediaSelectionState;
}
