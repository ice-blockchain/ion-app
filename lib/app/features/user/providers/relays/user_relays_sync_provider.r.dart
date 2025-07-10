// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.r.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.r.dart';
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
@Riverpod(keepAlive: true)
Future<void> userRelaysSync(Ref ref) async {
  final authState = await ref.watch(authProvider.future);

  if (!authState.isAuthenticated) {
    return;
  }

  final masterPubkey = ref.watch(currentPubkeySelectorProvider);
  final identity = await ref.watch(currentUserIdentityProvider.future);
  final identityConnectRelays = identity?.ionConnectRelays;
  final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;

  if (masterPubkey == null ||
      identity == null ||
      identityConnectRelays == null ||
      !delegationComplete) {
    return;
  }

  final userRelays = await ref.watch(userRelayProvider(masterPubkey).future);

  if (userRelays != null && !listEquals(userRelays.urls, identityConnectRelays)) {
    final updatedUserRelays = UserRelaysData(
      list: identityConnectRelays.map((url) => UserRelay(url: url)).toList(),
    );
    await ref
        .watch(ionConnectNotifierProvider.notifier)
        .sendEntityData<UserRelaysEntity>(updatedUserRelays);
    ref
      ..invalidate(userRelayProvider(masterPubkey))
      // invalidate feedFilterRelaysProvider manually because ref.read is used there
      ..invalidate(feedFilterRelaysProvider);
  }
}
