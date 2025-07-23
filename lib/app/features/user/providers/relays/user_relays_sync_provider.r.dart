// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/user_relays_manager.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_relays_sync_provider.r.g.dart';

/// Sync relays from identity and connect.
///
/// Relays specified in 10002 might obsolete, so syncing those by taking always
/// up to date ones from identity.
///
@Riverpod(keepAlive: true)
Future<void> userRelaysSync(Ref ref) async {
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

  //TODO[REFACTOR] - make _fetchRelaysFromIndexers public, use it here
  final userRelays = await ref.watch(userRelaysManagerProvider.notifier).fetch([masterPubkey]);
  final connectUserRelays = userRelays.firstOrNull?.data.list;

  if (!UserRelaysManager.relayListsEqual(connectUserRelays, identityUserRelays)) {
    final updatedUserRelays = UserRelaysData(list: identityUserRelays);
    await ref.watch(ionConnectNotifierProvider.notifier).sendEntityData(updatedUserRelays);
  }
}
