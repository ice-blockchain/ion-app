// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';

part 'image_processor_state.c.freezed.dart';

@freezed
sealed class ImageProcessorState with _$ImageProcessorState {
  const factory ImageProcessorState.initial() = ImageProcessorStateInitial;
  const factory ImageProcessorState.picked({required MediaFile file}) = ImageProcessorStatePicked;
  const factory ImageProcessorState.cropped({required MediaFile file}) = ImageProcessorStateCropped;
  const factory ImageProcessorState.processed({required MediaFile file}) =
      ImageProcessorStateProcessed;
  const factory ImageProcessorState.error({required String message}) = ImageProcessorStateError;
}
