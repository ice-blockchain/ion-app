// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/providers/cloud_storage/cloud_storage_service.c.dart';
import 'package:ion/app/services/providers/encryptor/aes_gcm_encryptor.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recovery_key_cloud_backup_restore_notifier.c.g.dart';

@riverpod
class RecoveryKeyCloudBackupRestoreNotifier extends _$RecoveryKeyCloudBackupRestoreNotifier {
  @override
  Future<RecoveryCredentials?> build() async => null;

  Future<void> restore({
    required String identityKeyName,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      try {
        final cloudStorage = ref.read(cloudStorageProvider);
        final fileContent = await cloudStorage.downloadFile('ion/$identityKeyName.json');
        if (fileContent == null) {
          throw RecoveryKeysFileDoesNotExistException();
        }

        final decryptedCredentials = await ref.read(aesGcmEncryptorProvider).decrypt(
              fileContent,
              password,
            );
        final credentialsMap = jsonDecode(decryptedCredentials) as Map<String, dynamic>;
        final credentials = RecoveryCredentials.fromJson(credentialsMap);
        return credentials;
      } catch (e) {
        if (e is DecryptIncorrectPasswordException) {
          throw RecoveryKeysRestoreIncorrectPasswordException();
        }
        throw RecoveryKeysRestoreFailedException(e);
      }
    });
  }
}
