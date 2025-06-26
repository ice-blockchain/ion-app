// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/user/model/user_file_storage_relays.f.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
import 'package:ion/app/features/user/providers/user_file_storage_relay_provider.r.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.r.dart';
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
  final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;
  final userRelays = await ref.watch(currentUserRelaysProvider.future);

  if (masterPubkey == null || userRelays == null || !delegationComplete) {
    return;
  }

  final relayUrls = userRelays.urls;

  final userFileStorageRelays =
      await ref.watch(userFileStorageRelayProvider(pubkey: masterPubkey).future);
  if (userFileStorageRelays != null) {
    final fileStorageRelays = userFileStorageRelays.data.list.map((e) => e.url).toSet();
    if (const SetEquality<String>().equals(fileStorageRelays, relayUrls.toSet())) {
      return;
    }
  }

  final fileStorageRelays = UserFileStorageRelaysData(
    list: relayUrls.map((url) => UserRelay(url: url)).toList(),
  );

  await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(fileStorageRelays);
  ref.invalidate(userFileStorageRelayProvider(pubkey: masterPubkey));
}
