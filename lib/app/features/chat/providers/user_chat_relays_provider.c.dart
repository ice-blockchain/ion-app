// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_chat_relays.c.dart';
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
    final entity = ref.read(
      ionConnectCacheProvider.select(
        cacheSelector(CacheableEntity.cacheKeyBuilder(eventReference: eventReference)),
      ),
    );
    if (entity != null) {
      return entity as UserChatRelaysEntity;
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
    return ref.read(ionConnectNotifierProvider.notifier).requestEntity(
          requestMessage,
          actionSource: ActionSourceUser(eventReference.pubkey),
        );
  }
}
