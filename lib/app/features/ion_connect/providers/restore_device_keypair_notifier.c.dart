// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_dialog_manager.c.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_utils.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restore_device_keypair_notifier.c.g.dart';

@riverpod
class RestoreDeviceKeypairNotifier extends _$RestoreDeviceKeypairNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> restoreDeviceKeypair({
    required UserActionSignerNew signer,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      try {
        final currentIdentityKeyName = _getCurrentIdentityKeyName();
        final deviceKey = await _findDeviceKey();
        final fileId = _extractFileIdFromKeyName(deviceKey.name);

        final derivation = await DeviceKeypairUtils.generateDerivation(
          ref: ref,
          keyId: deviceKey.id,
          signer: signer,
        );

        final encryptedData = await DeviceKeypairUtils.downloadEncryptedKeypair(fileId, ref);
        final decryptedPrivateKey = await DeviceKeypairUtils.decryptDeviceKeypair(
          encryptedData,
          derivation.output,
        );

        await _restoreKeypairToDevice(decryptedPrivateKey, currentIdentityKeyName);

        // Mark as completed
        final dialogManager = ref.read(deviceKeypairDialogManagerProvider.notifier);
        await dialogManager.markCompleted();
      } catch (error) {
        throw DeviceKeypairRestoreException(error);
      }
    });
  }

  Future<List<String>> listAvailableDeviceKeys() async {
    final deviceKeys = await DeviceKeypairUtils.findDeviceKeys(ref: ref);
    return deviceKeys.map((key) => key.name!).toList();
  }

  String _getCurrentIdentityKeyName() {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (currentIdentityKeyName == null) {
      throw const CurrentUserNotFoundException();
    }
    return currentIdentityKeyName;
  }

  Future<KeyResponse> _findDeviceKey() async {
    final deviceKeys = await DeviceKeypairUtils.findDeviceKeys(ref: ref);
    if (deviceKeys.isEmpty) {
      throw DeviceKeypairRestoreException('No device keys found');
    }
    return deviceKeys.first;
  }

  String _extractFileIdFromKeyName(String? keyName) {
    final compressedFileId = DeviceKeypairUtils.extractCompressedFileIdFromKeyName(keyName);
    if (compressedFileId == null) {
      throw DeviceKeypairRestoreException('Invalid device key name format');
    }

    return DeviceKeypairUtils.expandFileIdFromKeyName(compressedFileId);
  }

  /// Restores the decrypted keypair to the device storage and returns the event signer
  Future<EventSigner> _restoreKeypairToDevice(
    String privateKey,
    String identityKeyName,
  ) async {
    // Restore the keypair using the ion connect event signer provider
    final eventSignerNotifier = ref.read(ionConnectEventSignerProvider(identityKeyName).notifier);

    // Use the restoreFromPrivateKey method to restore the keypair
    return eventSignerNotifier.restoreFromPrivateKey(privateKey);
  }
}
