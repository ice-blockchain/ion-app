import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/gallery/data/models/media_data.dart';

part 'media_selection_state.freezed.dart';

@Freezed(copyWith: true, equal: true)
class MediaSelectionState with _$MediaSelectionState {
  const factory MediaSelectionState({
    required List<MediaData> selectedMedia,
  }) = _MediaSelectionState;
}
