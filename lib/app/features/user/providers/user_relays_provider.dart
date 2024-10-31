// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/user_relays.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_relays_provider.g.dart';

@Riverpod(keepAlive: true)
class UserRelays extends _$UserRelays {
  @override
  Future<UserRelaysEntity?> build(String pubkey) async {
    // TODO:remove when our relays are used, using nostr.band by then as the fastest one
    final userRelaysStub = UserRelaysEntity(
      id: '',
      createdAt: DateTime.now(),
      pubkey: pubkey,
      data: const UserRelaysData(list: [UserRelay(url: 'wss://relay.nostr.band')]),
    );

    /// Using approach with listening to the cache and notifier provider
    /// instead of ref.watch(nostrCacheProvider...) so that we could call this
    /// provider in other notifier's methods:
    /// ref.read(userRelaysProvider...)
    ref.listen(nostrCacheProvider.select(cacheSelector<UserRelaysEntity>(pubkey)), (prev, next) {
      if (next != prev) {
        // state = AsyncData(next);
        state = AsyncData(userRelaysStub);
      }
    });

    final cached = ref.read(nostrCacheProvider.select(cacheSelector<UserRelaysEntity>(pubkey)));
    if (cached != null) {
      return cached;
    }

    final requestMessage = RequestMessage()
      ..addFilter(RequestFilter(kinds: const [UserRelaysEntity.kind], authors: [pubkey], limit: 1));
    final userRelays =
        await ref.watch(nostrNotifierProvider.notifier).requestEntity<UserRelaysEntity>(
              requestMessage,
              actionSource: const ActionSourceIndexers(),
            );

    if (userRelays == null) {
      //TODO:
      // request to identity->get-user for the provided `pubkey` when implemented
      // and return them here if found:
      // ref.read(nostrCacheProvider.notifier).cache(userRelays);
      // return ...
    }

    return userRelaysStub;
    // return userRelays;
  }
}

@Riverpod(keepAlive: true)
Future<UserRelaysEntity?> currentUserRelays(Ref ref) async {
  final currentUserNostrKey = await ref.watch(currentUserNostrKeyStoreProvider.future);
  if (currentUserNostrKey == null) {
    return null;
  }
  return ref.watch(userRelaysProvider(currentUserNostrKey.publicKey).future);
}
