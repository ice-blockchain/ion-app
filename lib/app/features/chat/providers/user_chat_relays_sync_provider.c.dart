// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_relays_sync_provider.c.g.dart';

/// Fetches user relays and sets them as chat relays if they differ
/// If chat relays already match user relays, does nothing
/// Signs and broadcasts new chat relay list if an update is needed
///
@Riverpod(keepAlive: true)
Future<void> userChatRelaysSync(Ref ref) async {
  final authState = await ref.watch(authProvider.future);

  if (!authState.isAuthenticated) {
    return;
  }

  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;
  final userRelays = ref.watch(currentUserRelayProvider).valueOrNull;

  if (currentPubkey == null || userRelays == null || !delegationComplete) {
    return;
  }

  final relayUrls = userRelays.urls;

  final userChatRelays = await ref.watch(userChatRelaysProvider(currentPubkey).future);
  if (userChatRelays != null) {
    final chatRelays = userChatRelays.data.list.map((e) => e.url).toList();
    if (chatRelays.toSet().containsAll(relayUrls) && relayUrls.toSet().containsAll(chatRelays)) {
      return;
    }
  }

  final chatRelays = UserChatRelaysData(
    list: relayUrls.map((url) => UserRelay(url: url)).toList(),
  );

  await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(chatRelays);
  ref.invalidate(userChatRelaysProvider(currentPubkey));
}
