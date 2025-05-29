// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_constants.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_dialog_manager.c.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_utils.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_device_keypair_notifier.c.g.dart';

@riverpod
class UploadDeviceKeypairNotifier extends _$UploadDeviceKeypairNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> uploadDeviceKeypair({
    required String identityKeyName,
    required UserActionSignerNew signer,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final deviceKeypair = await _getDeviceKeypair();
        final deviceKey = await DeviceKeypairUtils.findOrCreateDeviceKey(
          ref: ref,
          signer: signer,
        );
        final derivation = await DeviceKeypairUtils.generateDerivation(
          ref: ref,
          keyId: deviceKey.id,
          signer: signer,
        );

        final encryptedKeypair = await _encryptDeviceKeypair(
          deviceKeypair.privateKey,
          derivation.output,
        );

        final uploadResult = await _uploadEncryptedKeypair(encryptedKeypair);
        await ref
            .read(ionConnectNotifierProvider.notifier)
            .sendEntityData(uploadResult.fileMetadata);
        await _renameKeyWithFileId(deviceKey.id, uploadResult.fileMetadata.url, signer);

        // Mark as completed and uploaded from this device
        final dialogManager = ref.read(deviceKeypairDialogManagerProvider.notifier);
        await dialogManager.markCompleted();
        await dialogManager.markUploadedFromThisDevice();
      } catch (error) {
        throw DeviceKeypairUploadException(error);
      }
    });
  }

  Future<EventSigner> _getDeviceKeypair() async {
    final deviceKeypair = await ref.read(currentUserIonConnectEventSignerProvider.future);
    if (deviceKeypair == null) {
      throw DeviceKeypairUploadException('Device keypair not found');
    }
    return deviceKeypair;
  }

  Future<void> _renameKeyWithFileId(
    String keyId,
    String? url,
    UserActionSignerNew signer,
  ) async {
    final fileId = DeviceKeypairUtils.extractFileIdFromUrl(url);
    if (fileId == null) {
      Logger.log('Warning: Could not extract file ID from URL: $url');
      return;
    }

    try {
      final compressedFileId = DeviceKeypairUtils.compressFileIdForKeyName(fileId);
      final newKeyName = '${DeviceKeypairConstants.keyName}-$compressedFileId';

      final ionIdentity = await ref.read(ionIdentityClientProvider.future);
      await ionIdentity.keys.updateKey(
        keyId: keyId,
        name: newKeyName,
        signer: signer,
      );
    } catch (e) {
      Logger.log(
        'Warning: Failed to rename key with compressed file ID',
        error: e,
      );
    }
  }

  /// Encrypts the device keypair using AES-GCM with the derivation output as the key
  Future<Uint8List> _encryptDeviceKeypair(String privateKey, String derivationOutput) async {
    final raw =
        derivationOutput.startsWith('0x') ? derivationOutput.substring(2) : derivationOutput;
    final keyBytes = hex.decode(raw);
    final secretKey = SecretKey(keyBytes.take(32).toList());

    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(utf8.encode(privateKey), secretKey: secretKey);

    final encryptedData = {
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    return Uint8List.fromList(utf8.encode(jsonEncode(encryptedData)));
  }

  /// Uploads the encrypted keypair to relays using the existing NIP-94 infrastructure
  Future<({FileMetadata fileMetadata, MediaAttachment mediaAttachment})> _uploadEncryptedKeypair(
    Uint8List encryptedData,
  ) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/device_keypair');
    await tempFile.writeAsBytes(encryptedData);

    final mediaFile = MediaFile(
      width: 1,
      height: 1,
      path: tempFile.path,
      mimeType: 'application/octet-stream',
    );

    try {
      return await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
            mediaFile,
            alt: FileAlt.message,
          );
    } finally {
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
    }
  }
}
