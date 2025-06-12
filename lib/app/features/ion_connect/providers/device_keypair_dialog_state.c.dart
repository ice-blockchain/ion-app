// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_keypair_dialog_state.c.freezed.dart';

/// Represents the current state of device keypair synchronization
enum DeviceKeypairState {
  /// No device key exists, need to start upload flow
  needsUpload,

  /// Device key exists but upload incomplete, need to continue upload
  uploadInProgress,

  /// Uploaded device keys exist from other devices, need to restore
  needsRestore,

  /// User has already completed upload/restore on this device
  completed,

  /// User rejected the action during current session
  rejectedThisSession,
}

/// Session state for tracking user rejections during current app session
@freezed
class DeviceKeypairSessionState with _$DeviceKeypairSessionState {
  const factory DeviceKeypairSessionState({
    @Default(false) bool rejected,
  }) = _DeviceKeypairSessionState;
}
