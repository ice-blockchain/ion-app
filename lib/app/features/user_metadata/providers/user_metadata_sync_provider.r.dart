// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.r.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/features/user_metadata/database/dao/user_metadata_dao.m.dart';
import 'package:ion/app/services/storage/local_storage.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_sync_provider.r.g.dart';

@riverpod
class UserMetadataSync extends _$UserMetadataSync {
  static const String localStorageKey = 'user_metadata_last_sync';

  @override
  Future<void> build() async {
    final keepAlive = ref.keepAlive();
    onLogout(ref, keepAlive.close);

    final authState = await ref.watch(authProvider.future);
    if (!authState.isAuthenticated) return;

    final delegationComplete = await ref.watch(delegationCompleteProvider.future);
    if (!delegationComplete) return;
  }

  Future<void> syncUserMetadata({
    bool forceSync = false,
    Set<String> masterPubkeys = const {},
  }) async {
    final masterPubkey = ref.watch(currentPubkeySelectorProvider);

    if (masterPubkey == null) throw UserMasterPubkeyNotFoundException();

    final userMetadataDao = ref.watch(userMetadataDaoProvider);

    final existingMasterPubkeys = await userMetadataDao.getExistingMasterPubkeys();

    final masterPubkeysDifference = masterPubkeys.difference(existingMasterPubkeys);

    final masterPubkeysToSync = Set<String>.from(existingMasterPubkeys)..addAll(masterPubkeys);

    final syncWindow =
        ref.read(envProvider.notifier).get<int>(EnvVariable.USER_METADATA_SYNC_MINUTES);

    final localStorage = await ref.watch(localStorageAsyncProvider.future);

    final lastSyncTime = DateTime.tryParse(localStorage.getString(localStorageKey) ?? '');

    if (forceSync ||
        lastSyncTime == null ||
        masterPubkeysDifference.isNotEmpty ||
        lastSyncTime.isBefore(DateTime.now().subtract(Duration(minutes: syncWindow)))) {
      final usersMetadata = await _fetchUsersMetadata(ref: ref, masterPubkeys: masterPubkeysToSync);

      if (usersMetadata.isEmpty) return;

      // If relay returned null for a master pubkey, we should remove existing metadata
      final deletedUsers =
          masterPubkeysToSync.difference(usersMetadata.map((e) => e.masterPubkey).toSet());

      await userMetadataDao.insertAll(usersMetadata);
      await userMetadataDao.deleteMetadata(deletedUsers.toList());

      await localStorage.setString(localStorageKey, DateTime.now().toIso8601String());
    }
  }

  Future<List<UserMetadataEntity>> _fetchUsersMetadata({
    required Ref ref,
    required Set<String> masterPubkeys,
  }) async {
    if (masterPubkeys.isEmpty) return [];

    final usersMetadata = await Future.wait(
      masterPubkeys
          .map((pubkey) => ref.read(userMetadataProvider(pubkey, cache: false).future))
          .toList(),
    );

    return usersMetadata.nonNulls.toList();
  }
}
