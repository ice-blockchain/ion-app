// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/mute_set.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'muted_users_notifier.c.g.dart';

@riverpod
class MutedUsers extends _$MutedUsers {
  @override
  FutureOr<void> build() async {}

  Future<void> toggleMutedMasterPubkey(String masterPubkey) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final existingMutedMasterPubkeys =
          ref.read(cachedMutedUsersProvider)?.data.masterPubkeys ?? [];

      final newMutedMasterPubkeys = existingMutedMasterPubkeys.contains(masterPubkey)
          ? existingMutedMasterPubkeys.where((p) => p != masterPubkey).toList()
          : [...existingMutedMasterPubkeys, masterPubkey];

      final MuteSetData muteSetData;

      muteSetData = MuteSetData(
        type: MuteSetType.notInterested,
        masterPubkeys: newMutedMasterPubkeys,
      );

      await ref.read(ionConnectNotifierProvider.notifier).sendEntityData<MuteSetEntity>(
            muteSetData,
          );
    });
  }
}

@riverpod
MuteSetEntity? cachedMutedUsers(Ref ref) {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return ref.watch(
    ionConnectSyncEntityProvider(
      eventReference: ReplaceableEventReference(
        pubkey: currentUserMasterPubkey,
        kind: MuteSetEntity.kind,
        dTag: MuteSetType.notInterested.dTagName,
      ),
    ),
  ) as MuteSetEntity?;
}

@riverpod
bool isUserMuted(Ref ref, String pubkey) {
  return ref.watch(
    cachedMutedUsersProvider.select(
      (mutedUsers) => mutedUsers?.data.masterPubkeys.contains(pubkey) ?? false,
    ),
  );
}
