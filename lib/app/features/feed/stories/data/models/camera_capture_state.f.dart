// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';

part 'camera_capture_state.f.freezed.dart';

@freezed
sealed class CameraCaptureState with _$CameraCaptureState {
  const factory CameraCaptureState.initial() = CameraCaptureInitial;
  const factory CameraCaptureState.recording() = CameraCaptureRecording;
  const factory CameraCaptureState.saved({required MediaFile file}) = CameraCaptureSaved;
  const factory CameraCaptureState.error({required String message}) = CameraCaptureError;
}
