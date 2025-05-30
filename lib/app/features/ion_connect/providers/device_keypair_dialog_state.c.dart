// SPDX-License-Identifier: ice License 1.0

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
class DeviceKeypairSessionState {
  DeviceKeypairSessionState({
    this.uploadRejected = false,
    this.restoreRejected = false,
  });

  final bool uploadRejected;
  final bool restoreRejected;

  DeviceKeypairSessionState copyWith({
    bool? uploadRejected,
    bool? restoreRejected,
  }) {
    return DeviceKeypairSessionState(
      uploadRejected: uploadRejected ?? this.uploadRejected,
      restoreRejected: restoreRejected ?? this.restoreRejected,
    );
  }
}
