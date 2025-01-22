// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_relays_provider.c.g.dart';

@riverpod
Future<UserChatRelaysEntity?> userChatRelays(Ref ref, String pubkey) async {
  final cached = ref.watch(
    ionConnectCacheProvider.select<UserChatRelaysEntity?>(
      cacheSelector(
        CacheableEntity.cacheKeyBuilder(
          eventReference:
              ReplaceableEventReference(pubkey: pubkey, kind: UserChatRelaysEntity.kind),
        ),
      ),
    ),
  );
  if (cached != null) return cached;

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(kinds: const [UserChatRelaysEntity.kind], authors: [pubkey]),
    );

  return ref.watch(ionConnectNotifierProvider.notifier).requestEntity<UserChatRelaysEntity>(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
}

@riverpod
class UserChatRelaysManager extends _$UserChatRelaysManager {
  @override
  FutureOr<void> build() async {}

  ///
  /// Fetches user relays and sets them as chat relays if they differ
  /// If chat relays already match user relays, does nothing
  /// Signs and broadcasts new chat relay list if an update is needed
  ///
  Future<void> sync() async {
    final pubkey = await ref.read(currentPubkeySelectorProvider.future);
    if (pubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final userRelays = await ref.read(userRelaysManagerProvider.notifier).fetch([pubkey]);
    final relayUrls = userRelays.first.data.list.map((e) => e.url).toList();

    final userChatRelays = await ref.read(userChatRelaysProvider(pubkey).future);
    if (userChatRelays != null) {
      final chatRelays = userChatRelays.data.list.map((e) => e.url).toList();
      if (chatRelays.toSet().containsAll(relayUrls) && relayUrls.toSet().containsAll(chatRelays)) {
        return;
      }
    }

    final chatRelays = UserChatRelaysData(
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    final chatRelaysEvent = await ref.read(ionConnectNotifierProvider.notifier).sign(chatRelays);

    await ref.read(ionConnectNotifierProvider.notifier).sendEvents([chatRelaysEvent]);
    ref.invalidate(userChatRelaysProvider(pubkey));
  }
}
