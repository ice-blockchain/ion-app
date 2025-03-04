// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/services/cloud_storage/cloud_storage_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recovery_key_cloud_backup_restore_notifier.c.g.dart';

@riverpod
class RecoveryKeyCloudBackupRestoreNotifier extends _$RecoveryKeyCloudBackupRestoreNotifier {
  @override
  FutureOr<Map<String, dynamic>> build() async => {};

  Future<void> restore(
    String identityKeyName,
  ) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final cloudStorage = ref.read(cloudStorageProvider);
      final fileContent = await cloudStorage.downloadFile('ion/$identityKeyName.json');
      if (fileContent == null) {
        throw RecoveryKeysRestoreFailedException();
      }
      // TODO: Decrypt the file first
      final fileMap = jsonDecode(fileContent) as Map<String, dynamic>;
      return fileMap;
    });
  }
}
