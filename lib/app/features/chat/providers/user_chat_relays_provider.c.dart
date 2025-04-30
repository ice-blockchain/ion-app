// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
import 'package:ion/app/features/user/providers/relays_reachability_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_chat_relays_provider.c.g.dart';

@riverpod
Future<UserChatRelaysEntity?> userChatRelays(Ref ref, String pubkey) async {
  return ref.read(userChatRelaysManagerProvider.notifier).fetch(pubkey);
}

@riverpod
class UserChatRelaysManager extends _$UserChatRelaysManager {
  @override
  FutureOr<void> build() async {}

  Future<UserChatRelaysEntity?> fetch(String pubkey) async {
    final eventReference =
        ReplaceableEventReference(pubkey: pubkey, kind: UserChatRelaysEntity.kind);
    final entity = (await ref.read(ionConnectDbCacheProvider.notifier).get([eventReference]))
        .cast<UserChatRelaysEntity?>()
        .nonNulls
        .firstOrNull;
    final filteredRelayEntity =
        ref.read(relayReachabilityProvider.notifier).getFilteredChatRelayEntity(entity);

    if (filteredRelayEntity != null) {
      return filteredRelayEntity;
    }

    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: [eventReference.kind],
          authors: [eventReference.pubkey],
          tags: {
            if (eventReference.dTag != null) '#d': [eventReference.dTag.toString()],
          },
          limit: 1,
        ),
      );
    final relay = await ref.read(ionConnectNotifierProvider.notifier).requestEntity(
          requestMessage,
          actionSource: ActionSourceUser(eventReference.pubkey),
        );

    if (relay != null && relay is UserChatRelaysEntity) {
      await _clearReachabilityInfoFor(relay.urls);
    }

    return relay as UserChatRelaysEntity?;
  }

  Future<void> _clearReachabilityInfoFor(
    List<String> relaysUrls,
  ) async {
    final reachabilityInfoNotifier = ref.read(relayReachabilityProvider.notifier);
    for (final url in relaysUrls) {
      await reachabilityInfoNotifier.clear(url);
    }
  }
}
