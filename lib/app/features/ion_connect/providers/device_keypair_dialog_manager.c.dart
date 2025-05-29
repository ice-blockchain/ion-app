// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_constants.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_dialog_state.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_keypair_dialog_manager.c.g.dart';

@riverpod
class DeviceKeypairDialogManager extends _$DeviceKeypairDialogManager {
  static const String _completedKeyPrefix = 'device_keypair_completed';
  static const String _uploadedFromDeviceKeyPrefix = 'device_keypair_uploaded_from_device';

  @override
  DeviceKeypairSessionState build() {
    return DeviceKeypairSessionState();
  }

  /// Gets user-specific storage key for completion status
  String _getCompletedKey() {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null) {
      throw const CurrentUserNotFoundException();
    }
    return '${_completedKeyPrefix}_$identityKeyName';
  }

  /// Gets user-specific storage key for upload-from-device status
  String _getUploadedFromDeviceKey() {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null) {
      throw const CurrentUserNotFoundException();
    }
    return '${_uploadedFromDeviceKeyPrefix}_$identityKeyName';
  }

  /// Determines the current state of device keypair synchronization
  Future<DeviceKeypairState> getCurrentState() async {
    try {
      // Check if user completed upload/restore on this device
      final hasCompleted = await _hasCompletedOnThisDevice();
      if (hasCompleted) {
        return DeviceKeypairState.completed;
      }

      // Check session rejections
      if (state.uploadRejected || state.restoreRejected) {
        return DeviceKeypairState.rejectedThisSession;
      }

      // Check if user uploaded from this device (don't ask to restore)
      final uploadedFromThisDevice = await _hasUploadedFromThisDevice();
      if (uploadedFromThisDevice) {
        return DeviceKeypairState.completed;
      }

      // Get all keys to determine state
      final ionIdentity = await ref.read(ionIdentityClientProvider.future);
      final keysResponse = await ionIdentity.keys.listKeys();

      // First check for device keys linked to uploaded files (device-*) - these indicate we should restore
      final signingKeys = keysResponse.items
          .where((key) => key.name?.startsWith('${DeviceKeypairConstants.keyName}-') ?? false)
          .toList();

      // If device keys are linked to uploaded files, user should restore
      if (signingKeys.isNotEmpty) {
        return DeviceKeypairState.needsRestore;
      }

      // Then check for base device key
      final hasDeviceKey = keysResponse.items.any(
        (key) => key.name == DeviceKeypairConstants.keyName,
      );

      // If base device key exists, upload is in progress
      if (hasDeviceKey) {
        return DeviceKeypairState.uploadInProgress;
      }

      // If no keys exist at all, need to start upload
      return DeviceKeypairState.needsUpload;
    } catch (e) {
      // If any error occurs, assume we need to start upload
      return DeviceKeypairState.needsUpload;
    }
  }

  /// Marks that the user rejected the upload action
  void rejectUpload() {
    state = state.copyWith(uploadRejected: true);
  }

  /// Marks that the user rejected the restore action
  void rejectRestore() {
    state = state.copyWith(restoreRejected: true);
  }

  /// Marks that the user completed upload/restore on this device
  Future<void> markCompleted() async {
    final localStorage = ref.read(localStorageProvider);
    await localStorage.setBool(key: _getCompletedKey(), value: true);
  }

  /// Marks that the user uploaded from this device
  Future<void> markUploadedFromThisDevice() async {
    final localStorage = ref.read(localStorageProvider);
    await localStorage.setBool(key: _getUploadedFromDeviceKey(), value: true);
  }

  /// Checks if user has completed upload/restore on this device
  Future<bool> _hasCompletedOnThisDevice() async {
    try {
      final localStorage = ref.read(localStorageProvider);
      return localStorage.getBool(_getCompletedKey()) ?? false;
    } catch (e) {
      Logger.log('Error checking completion status', error: e);
      return false;
    }
  }

  /// Checks if user uploaded from this device
  Future<bool> _hasUploadedFromThisDevice() async {
    try {
      final localStorage = ref.read(localStorageProvider);
      return localStorage.getBool(_getUploadedFromDeviceKey()) ?? false;
    } catch (e) {
      Logger.log('Error checking upload status', error: e);
      return false;
    }
  }

  /// Resets all persistent state (for testing/debugging)
  Future<void> resetState() async {
    final localStorage = ref.read(localStorageProvider);
    await localStorage.remove(_getCompletedKey());
    await localStorage.remove(_getUploadedFromDeviceKey());
    state = DeviceKeypairSessionState();
  }
}
