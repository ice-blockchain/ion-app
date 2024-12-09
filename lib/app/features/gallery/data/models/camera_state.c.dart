// SPDX-License-Identifier: ice License 1.0

import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_state.c.freezed.dart';

@freezed
sealed class CameraState with _$CameraState {
  const factory CameraState.initial() = _CameraInitial;
  const factory CameraState.loading() = _CameraLoading;
  const factory CameraState.ready({
    required CameraController controller,
    @Default(false) bool isRecording,
    @Default(false) bool isFlashOn,
  }) = CameraReady;
  const factory CameraState.error({
    required String message,
  }) = CameraError;
}
