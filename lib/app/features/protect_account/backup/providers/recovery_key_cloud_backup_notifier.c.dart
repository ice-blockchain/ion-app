// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/services/cloud_storage/cloud_storage_service.c.dart';
import 'package:ion/app/services/encryptor/aes_gcm_encryptor.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recovery_key_cloud_backup_notifier.c.g.dart';

@riverpod
class RecoveryKeyCloudBackupNotifier extends _$RecoveryKeyCloudBackupNotifier {
  @override
  Future<void> build() async => {};

  Future<void> backup({
    required RecoveryCredentials recoveryData,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final cloudStorage = ref.read(cloudStorageProvider);
      final credentialsJson = recoveryData.toJson();
      final credentialsString = jsonEncode(credentialsJson);
      final encryptedCredentials = await ref.read(aesGcmEncryptorProvider).encrypt(
            credentialsString,
            password,
          );
      await cloudStorage.uploadFile(
        'ion/${recoveryData.identityKeyName}.json',
        encryptedCredentials,
      );
    });
  }
}
