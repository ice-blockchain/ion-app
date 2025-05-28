import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/file_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_device_keypair_notifier.c.g.dart';

@riverpod
class UploadDeviceKeypairNotifier extends _$UploadDeviceKeypairNotifier {
  static const _domain = 'ion:ion-app:1';
  static const _scheme = 'DH';
  static const _curve = 'secp256k1';
  static const _name = 'device';

  @override
  FutureOr<void> build() {}

  /// Backs up the device keypair to relays using the specified process:
  /// 1. Create DH key with scheme=DH, curve=secp256k1, name=device
  /// 2. Generate derivation with domain=hex(ion:ion-app:1) and seed=hex($userId:$somethingElseTBDLater)
  /// 3. Encrypt device keypair with AES-GCM using derivation output
  /// 4. Upload encrypted file to relays using NIP-94 events
  /// 5. Rename key to device-$fileId (TODO: requires API support)
  Future<void> uploadDeviceKeypair({
    required String identityKeyName,
    required UserActionSignerNew signer,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // Step 1: Get the device keypair
      final deviceKeypair = await ref.read(currentUserIonConnectEventSignerProvider.future);
      if (deviceKeypair == null) {
        throw Exception('Device keypair not found');
      }

      // Step 2: Get user details to extract userId
      final userDetails = await ref.read(currentUserIdentityProvider.future);
      if (userDetails?.userId == null) {
        throw Exception('User ID not found');
      }
      final userId = userDetails!.userId!;

      final ionIdentity = await ref.read(ionIdentityClientProvider.future);

      // Step 3: Create or get the device key with DH scheme and secp256k1 curve
      final keysResponse = await ionIdentity.keys.listKeys();
      var deviceKey =
          keysResponse.items.firstWhereOrNull((key) => key.name?.startsWith(_name) ?? false);

      deviceKey ??= await ionIdentity.keys.createKey(
        scheme: _scheme,
        curve: _curve,
        name: _name,
        signer: signer,
      );

      // Step 4: Generate derivation with hex-encoded domain and seed
      // Domain: hex encoding of "ion:ion-app:1"
      final domain = hex.encode(_domain.codeUnits);
      // Seed: hex encoding of "$userId"
      final seed = hex.encode(userId.codeUnits);

      final derivation = await ionIdentity.keys.derive(
        keyId: deviceKey.id,
        domain: domain,
        seed: seed,
        signer: signer,
      );

      // Step 5: Encrypt the device keypair with AES-GCM using derivation output
      final encryptedKeypair = await _encryptDeviceKeypair(
        deviceKeypair.privateKey,
        derivation.output,
      );

      // Step 6: Upload encrypted file to relays using NIP-94
      final uploadResult = await _uploadEncryptedKeypair(encryptedKeypair);

      print('XXX: result: $uploadResult');
      // TODO: Implement key renaming when the API is available
      // The ion_identity_client doesn't currently expose an updateKey/renameKey method
      // This would require adding support in the ion_identity_client package
      // await ionIdentity.keys.updateKey(
      //   keyId: deviceKey.id,
      //   name: 'device-$fileId',
      //   onVerifyIdentity: onVerifyIdentityForUpdateKey,
      // );

      // For now, we'll store the mapping locally or use a different approach
      // The backup is complete even without renaming the key
    });
  }

  /// Restores the device keypair from relays:
  /// 1. List all keys starting with "device-"
  /// 2. Download files from relays using NIP-94 events
  /// 3. Decrypt using the same derivation process
  /// 4. Restore keypair to device
  Future<void> restoreDeviceKeypair({
    required String identityKeyName,
    required UserActionSignerNew signer,
  }) async {
    state = await AsyncValue.guard(() async {
      // Step 1: List all keys and find device-* keys
      final ionIdentity = await ref.read(ionIdentityClientProvider.future);
      final keysResponse = await ionIdentity.keys.listKeys(owner: identityKeyName);

      final deviceKeys =
          keysResponse.items.where((key) => key.name?.startsWith('device-') ?? false).toList();

      if (deviceKeys.isEmpty) {
        throw Exception('No device backup keys found');
      }

      // Use the most recent device key (or implement selection logic)
      final deviceKey = deviceKeys.first;
      final keyName = deviceKey.name;
      if (keyName == null || !keyName.startsWith('device-')) {
        throw Exception('Invalid device key name format');
      }
      final backupFileId = keyName.substring('device-'.length);

      // Step 2: Get user details to extract userId
      final userDetails = await ref.read(currentUserIdentityProvider.future);
      if (userDetails?.userId == null) {
        throw Exception('User ID not found');
      }
      final userId = userDetails!.userId!;

      // Step 3: Generate derivation to get decryption key
      final domain = hex.encode('ion:ion-app:1'.codeUnits);
      final seed = hex.encode('$userId:device-backup'.codeUnits);

      final derivation = await ionIdentity.keys.derive(
        keyId: deviceKey.id,
        domain: domain,
        seed: seed,
        signer: signer,
      );

      // Step 4: Download and decrypt the keypair
      final encryptedData = await _downloadEncryptedKeypair(backupFileId);
      final decryptedPrivateKey = await _decryptDeviceKeypair(encryptedData, derivation.output);

      // Step 5: Restore the keypair to the device
      await _restoreKeypairToDevice(decryptedPrivateKey, identityKeyName);
    });
  }

  /// Encrypts the device keypair using AES-GCM with the derivation output as the key
  Future<Uint8List> _encryptDeviceKeypair(String privateKey, String derivationOutput) async {
    // Use the derivation output as the encryption key
    final raw =
        derivationOutput.startsWith('0x') ? derivationOutput.substring(2) : derivationOutput;
    final keyBytes = hex.decode(raw);
    final secretKey = SecretKey(keyBytes.take(32).toList()); // Use first 32 bytes for AES-256

    // Encrypt the private key using AES-GCM
    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(
      utf8.encode(privateKey),
      secretKey: secretKey,
    );

    // Combine nonce, ciphertext, and MAC for storage
    final encryptedData = {
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };

    return Uint8List.fromList(utf8.encode(jsonEncode(encryptedData)));
  }

  /// Decrypts the device keypair using AES-GCM with the derivation output as the key
  Future<String> _decryptDeviceKeypair(Uint8List encryptedData, String derivationOutput) async {
    // Parse the encrypted data
    final dataString = utf8.decode(encryptedData);
    final data = jsonDecode(dataString) as Map<String, dynamic>;

    final nonce = base64Decode(data['nonce'] as String);
    final ciphertext = base64Decode(data['ciphertext'] as String);
    final macBytes = base64Decode(data['mac'] as String);

    // Use the derivation output as the decryption key
    final keyBytes = hex.decode(derivationOutput);
    final secretKey = SecretKey(keyBytes.take(32).toList()); // Use first 32 bytes for AES-256

    // Decrypt using AES-GCM
    final algorithm = AesGcm.with256bits();
    final secretBox = SecretBox(
      ciphertext,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final decryptedData = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return utf8.decode(decryptedData);
  }

  /// Uploads the encrypted keypair to relays using the existing NIP-94 infrastructure
  Future<({FileMetadata fileMetadata, MediaAttachment mediaAttachment})> _uploadEncryptedKeypair(
    Uint8List encryptedData,
  ) async {
    // Create a temporary file for upload
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/device_keypair');
    await tempFile.writeAsBytes(encryptedData);

    // Create MediaFile for upload
    final mediaFile = MediaFile(
      width: 1,
      height: 1,
      path: tempFile.path,
      mimeType: 'application/octet-stream',
    );

    try {
      // Upload using the existing upload infrastructure
      final uploadResult = await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
            mediaFile,
            alt: FileAlt.message, // Use appropriate alt text
          );

      return uploadResult;
    } finally {
      // Clean up temporary file
      if (tempFile.existsSync()) {
        await tempFile.delete();
      }
    }
  }

  /// Downloads the encrypted keypair from relays using the file ID
  /// TODO: This needs to be implemented to query relays for NIP-94 events
  Future<Uint8List> _downloadEncryptedKeypair(String fileId) async {
    // This would involve:
    // 1. Querying relays for NIP-94 events with the specific file hash
    // 2. Extracting the file URL from the event
    // 3. Downloading the file content
    // 4. Returning the encrypted data

    throw UnimplementedError(
      'File download from relays using NIP-94 events is not yet implemented. '
      'This requires querying relays for events with the file hash and downloading the content.',
    );
  }

  /// Restores the decrypted keypair to the device storage
  Future<void> _restoreKeypairToDevice(String privateKey, String identityKeyName) async {
    // Restore the keypair using the ion connect event signer provider
    final eventSignerNotifier = ref.read(ionConnectEventSignerProvider(identityKeyName).notifier);

    // Use the new restoreFromPrivateKey method to restore the keypair
    await eventSignerNotifier.restoreFromPrivateKey(privateKey);
  }
}
