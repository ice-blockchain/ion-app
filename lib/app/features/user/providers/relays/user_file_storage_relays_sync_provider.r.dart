// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/user/model/user_file_storage_relays.f.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/user_file_storage_relays_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/user_relays_manager.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_file_storage_relays_sync_provider.r.g.dart';

/// Fetches user relays and sets them as file storage relays if they differ
/// If file storage relays already match user relays, does nothing
/// Signs and broadcasts new file storage relay list if an update is needed
///
@Riverpod(keepAlive: true)
Future<void> userFileStorageRelaysSync(Ref ref) async {
  final authState = await ref.watch(authProvider.future);

  if (!authState.isAuthenticated) {
    return;
  }

  final masterPubkey = ref.watch(currentPubkeySelectorProvider);
  final identityUserRelays = await ref.watch(currentUserIdentityConnectRelaysProvider.future);
  final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;

  if (masterPubkey == null || identityUserRelays == null || !delegationComplete) {
    return;
  }

  final fileStorageRelaysEntity =
      await ref.watch(userFileStorageRelaysProvider(pubkey: masterPubkey).future);
  final fileStorageUserRelays = fileStorageRelaysEntity?.data.list;

  if (!UserRelaysManager.relayListsEqual(fileStorageUserRelays, identityUserRelays)) {
    final fileStorageRelays = UserFileStorageRelaysData(list: identityUserRelays);
    await ref.watch(ionConnectNotifierProvider.notifier).sendEntityData(fileStorageRelays);
    ref.invalidate(userFileStorageRelaysProvider(pubkey: masterPubkey));
  }
}
