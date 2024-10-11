// SPDX-License-Identifier: ice License 1.0
import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_camera_state.freezed.dart';

@Freezed(copyWith: true, equal: true)
class StoryCameraState with _$StoryCameraState {
  const factory StoryCameraState({
    @Default(false) bool isRecording,
    @Default(false) bool isFlashOn,
  }) = _StoryCameraState;
}
