// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_camera_state.freezed.dart';

@freezed
sealed class StoryCameraState with _$StoryCameraState {
  const factory StoryCameraState.initial() = StoryCameraInitial;
  const factory StoryCameraState.recording() = StoryCameraRecording;
  const factory StoryCameraState.saved({required String videoPath}) = StoryCameraSaved;
  const factory StoryCameraState.uploading() = StoryCameraUploading;
  const factory StoryCameraState.published() = StoryCameraPublished;
  const factory StoryCameraState.error({required String message}) = StoryCameraError;
}
