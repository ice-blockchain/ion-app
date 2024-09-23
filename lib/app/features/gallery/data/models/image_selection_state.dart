import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/gallery/data/models/image_data.dart';

part 'image_selection_state.freezed.dart';

@Freezed(copyWith: true)
class ImageSelectionState with _$ImageSelectionState {
  const factory ImageSelectionState({
    required List<ImageData> selectedImages,
  }) = _ImageSelectionState;
}
