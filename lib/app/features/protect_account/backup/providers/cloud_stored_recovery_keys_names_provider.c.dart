// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/providers/cloud_storage/cloud_storage_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cloud_stored_recovery_keys_names_provider.c.g.dart';

@riverpod
Future<Set<String>> cloudStoredRecoveryKeysNames(Ref ref) async {
  final cloudStorage = ref.watch(cloudStorageProvider);
  final files = await cloudStorage.listFilesPaths(directory: 'ion');
  return files.map((file) => file.split('/').last.split('.').first).toSet();
}
