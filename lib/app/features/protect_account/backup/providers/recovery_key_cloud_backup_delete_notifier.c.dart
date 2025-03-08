// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/cloud_storage/cloud_storage_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recovery_key_cloud_backup_delete_notifier.c.g.dart';

@riverpod
class RecoveryKeyCloudBackupDeleteNotifier extends _$RecoveryKeyCloudBackupDeleteNotifier {
  @override
  Future<void> build() async => {};

  Future<void> remove({
    required String identityKeyName,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final cloudStorage = ref.read(cloudStorageProvider);
      await cloudStorage.deleteFile('ion/$identityKeyName.json');
    });
  }
}
