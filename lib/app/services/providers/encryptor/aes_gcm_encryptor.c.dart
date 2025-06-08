// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aes_gcm_encryptor.c.g.dart';

@riverpod
AesGcmEncryptor aesGcmEncryptor(Ref ref) => AesGcmEncryptor();

final class AesGcmEncryptor {
  Future<String> encrypt(String dataToEncrypt, String password) async {
    // Generate a random salt
    final salt = SecretKeyData.random(length: 16).bytes;

    // Derive a key from password and salt using PBKDF2
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac(Sha256()),
      iterations: 100000, // Increased iterations for added security
      bits: 256,
    );
    final secretKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    // Encrypt the data using AES-GCM
    final algorithm = AesGcm.with256bits();
    final secretBox = await algorithm.encrypt(
      utf8.encode(dataToEncrypt),
      secretKey: secretKey,
    );

    // Prepare the encrypted data for storage
    final encryptedData = {
      'salt': base64Encode(salt),
      'nonce': base64Encode(secretBox.nonce),
      'ciphertext': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    };
    final encryptedDataJson = jsonEncode(encryptedData);
    return encryptedDataJson;
  }

  Future<String> decrypt(String encryptedData, String password) async {
    try {
      // Parse the encrypted data
      final data = jsonDecode(encryptedData) as Map<String, dynamic>;
      final salt = base64Decode(data['salt'] as String);
      final nonce = base64Decode(data['nonce'] as String);
      final ciphertext = base64Decode(data['ciphertext'] as String);
      final macBytes = base64Decode(data['mac'] as String);

      // Derive the data from password and salt using PBKDF2
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac(Sha256()),
        iterations: 100000,
        bits: 256,
      );
      final secretKey = await pbkdf2.deriveKey(
        secretKey: SecretKey(utf8.encode(password)),
        nonce: salt,
      );

      // Decrypt the ciphertext using AES-GCM
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
      final decodedData = utf8.decode(decryptedData);
      return decodedData;
    } catch (e) {
      if (e is SecretBoxAuthenticationError) {
        throw DecryptIncorrectPasswordException();
      }
      rethrow;
    }
  }
}

final class DecryptIncorrectPasswordException implements Exception {}
