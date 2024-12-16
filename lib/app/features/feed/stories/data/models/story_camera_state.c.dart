// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

part 'story_camera_state.c.freezed.dart';

@freezed
sealed class StoryCameraState with _$StoryCameraState {
  const factory StoryCameraState.initial() = StoryCameraInitial;
  const factory StoryCameraState.recording() = StoryCameraRecording;
  const factory StoryCameraState.saved({required MediaFile file}) = StoryCameraSaved;
  const factory StoryCameraState.error({required String message}) = StoryCameraError;
}
