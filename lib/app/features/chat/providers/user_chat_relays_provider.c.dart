// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_relays_provider.c.g.dart';

@riverpod
Future<UserChatRelaysEntity?> userChatRelays(Ref ref, String pubkey) async {
  final cached = ref.watch(
    nostrCacheProvider.select<UserChatRelaysEntity?>(
      cacheSelector(UserChatRelaysEntity.cacheKeyBuilder(pubkey: pubkey)),
    ),
  );
  if (cached != null) return cached;

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(kinds: const [UserChatRelaysEntity.kind], authors: [pubkey]),
    );

  return ref.watch(nostrNotifierProvider.notifier).requestEntity<UserChatRelaysEntity>(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
}

class UserChatRelaysManager {
  UserChatRelaysManager(this.ref);

  final Ref ref;

  ///
  /// Fetches user relays and sets them as chat relays if they differ
  /// If chat relays already match user relays, does nothing
  /// Signs and broadcasts new chat relay list if an update is needed
  ///
  Future<void> sync() async {
    final pubkey = ref.watch(currentPubkeySelectorProvider);
    if (pubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final userRelays = await ref.watch(userRelaysManagerProvider.notifier).fetch([pubkey]);
    final relayUrls = userRelays.first.data.list.map((e) => e.url).toList();

    final userChatRelays = await ref.watch(userChatRelaysProvider(pubkey).future);
    if (userChatRelays != null) {
      final chatRelays = userChatRelays.data.list.map((e) => e.url).toList();
      if (chatRelays.toSet().containsAll(relayUrls) && relayUrls.toSet().containsAll(chatRelays)) {
        return;
      }
    }

    final chatRelays = UserChatRelaysData(
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    final chatRelaysEvent = await ref.read(nostrNotifierProvider.notifier).sign(chatRelays);

    await ref.read(nostrNotifierProvider.notifier).sendEvents([chatRelaysEvent]);
    ref.invalidate(userChatRelaysProvider(pubkey));
  }
}

@riverpod
UserChatRelaysManager userChatRelaysManager(Ref ref) {
  return UserChatRelaysManager(ref);
}
