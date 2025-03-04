// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/services/cloud_storage/cloud_storage_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recovery_key_cloud_backup_notifier.c.g.dart';

@riverpod
class RecoveryKeyCloudBackupNotifier extends _$RecoveryKeyCloudBackupNotifier {
  @override
  Future<void> build() async => {};

  Future<void> backup(
    String identityKeyName,
  ) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final cloudStorage = ref.read(cloudStorageProvider);
      // TODO: Create new recovery key and encrypt it
      final content = {'key1': 'value1', 'key2': 'value2'};
      final stringContent = jsonEncode(content);
      await cloudStorage.uploadFile('ion/$identityKeyName.json', stringContent);
    });
  }
}
