// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/device_keypair_constants.dart';
import 'package:ion/app/features/ion_connect/providers/file_storage_url_provider.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

/// Utility class for shared device keypair operations
class DeviceKeypairUtils {
  /// Finds or creates a device key for synchronization operations
  static Future<KeyResponse> findOrCreateDeviceKey({
    required Ref ref,
    required UserActionSignerNew signer,
  }) async {
    final ionIdentity = await ref.read(ionIdentityClientProvider.future);
    final keysResponse = await ionIdentity.keys.listKeys();

    return keysResponse.items.firstWhereOrNull(
          (key) => key.name?.startsWith(DeviceKeypairConstants.keyName) ?? false,
        ) ??
        await ionIdentity.keys.createKey(
          scheme: DeviceKeypairConstants.scheme,
          curve: DeviceKeypairConstants.curve,
          name: DeviceKeypairConstants.keyName,
          signer: signer,
        );
  }

  /// Generates derivation for device keypair encryption/decryption
  static Future<DeriveResponse> generateDerivation({
    required Ref ref,
    required String keyId,
    required UserActionSignerNew signer,
  }) async {
    final userDetails = await ref.read(currentUserIdentityProvider.future);
    if (userDetails?.userId == null) {
      throw Exception('User ID not found');
    }

    final ionIdentity = await ref.read(ionIdentityClientProvider.future);
    final domain = hex.encode(DeviceKeypairConstants.domain.codeUnits);
    final seed = hex.encode(userDetails!.userId!.codeUnits);

    return ionIdentity.keys.derive(
      keyId: keyId,
      domain: domain,
      seed: seed,
      signer: signer,
    );
  }

  /// Finds device keys for synchronization across devices
  static Future<List<KeyResponse>> findDeviceKeys({
    required Ref ref,
  }) async {
    final ionIdentity = await ref.read(ionIdentityClientProvider.future);
    final keysResponse = await ionIdentity.keys.listKeys();

    return keysResponse.items
        .where((key) => key.name?.startsWith('${DeviceKeypairConstants.keyName}-') ?? false)
        .toList();
  }

  /// Decrypts device keypair using AES-GCM
  static Future<String> decryptDeviceKeypair(
    Uint8List encryptedData,
    String derivationOutput,
  ) async {
    final dataString = utf8.decode(encryptedData);
    final data = jsonDecode(dataString) as Map<String, dynamic>;

    final nonce = base64Decode(data['nonce'] as String);
    final ciphertext = base64Decode(data['ciphertext'] as String);
    final macBytes = base64Decode(data['mac'] as String);

    final raw =
        derivationOutput.startsWith('0x') ? derivationOutput.substring(2) : derivationOutput;
    final keyBytes = hex.decode(raw);
    final secretKey = SecretKey(keyBytes.take(32).toList());

    final algorithm = AesGcm.with256bits();
    final secretBox = SecretBox(ciphertext, nonce: nonce, mac: Mac(macBytes));

    final decryptedData = await algorithm.decrypt(secretBox, secretKey: secretKey);
    return utf8.decode(decryptedData);
  }

  /// Downloads encrypted keypair from relays using proper file storage URL discovery
  static Future<Uint8List> downloadEncryptedKeypair(String fileId, Ref ref) async {
    final baseStorageUrl = await ref.read(fileStorageUrlProvider.future);
    final downloadUrl = '$baseStorageUrl/$fileId';

    final dio = ref.read(dioProvider);

    try {
      final response = await dio.get<List<int>>(
        downloadUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      }

      throw Exception('Failed to download file: HTTP ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to download encrypted keypair from $downloadUrl: $e');
    }
  }

  /// Extracts file ID from URL
  static String? extractFileIdFromUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    final uri = Uri.tryParse(url);
    if (uri?.pathSegments.isNotEmpty ?? false) {
      return uri!.pathSegments.last;
    }

    return null;
  }

  /// Converts hex file ID to base64 for shorter key names
  /// Example: "abc123:def456" -> "qsEj3e9FVg=="
  static String compressFileIdForKeyName(String fileId) {
    try {
      final parts = fileId.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid file ID format, expected hex:hex');
      }

      // Convert each hex part to bytes, then to base64
      final part1Bytes = hex.decode(parts[0]);
      final part2Bytes = hex.decode(parts[1]);

      final part1Base64 = base64Encode(part1Bytes);
      final part2Base64 = base64Encode(part2Bytes);

      return '$part1Base64:$part2Base64';
    } catch (e) {
      throw Exception('Failed to compress file ID: $e');
    }
  }

  /// Converts base64 file ID back to hex format
  /// Example: "qsEj3e9FVg==" -> "abc123:def456"
  static String expandFileIdFromKeyName(String compressedFileId) {
    try {
      final parts = compressedFileId.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid compressed file ID format, expected base64:base64');
      }

      // Convert each base64 part to bytes, then to hex
      final part1Bytes = base64Decode(parts[0]);
      final part2Bytes = base64Decode(parts[1]);

      final part1Hex = hex.encode(part1Bytes);
      final part2Hex = hex.encode(part2Bytes);

      return '$part1Hex:$part2Hex';
    } catch (e) {
      throw Exception('Failed to expand file ID: $e');
    }
  }

  /// Extracts the compressed file ID from a device key name
  /// Example: "device-qsEj3e9FVg==" -> "qsEj3e9FVg=="
  static String? extractCompressedFileIdFromKeyName(String? keyName) {
    if (keyName == null || !keyName.startsWith('${DeviceKeypairConstants.keyName}-')) {
      return null;
    }
    return keyName.substring('${DeviceKeypairConstants.keyName}-'.length);
  }
}
