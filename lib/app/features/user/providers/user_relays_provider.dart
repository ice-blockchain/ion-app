// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/nostr/providers/nostr_cache.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_relays.dart';
import 'package:ice/app/features/user/providers/current_user_indexers_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_relays_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserRelays?> userRelays(UserRelaysRef ref, String pubkey) async {
  final userRelays = ref.watch(nostrCache<UserRelays>(pubkey));
  if (userRelays != null) {
    return userRelays;
  }

  final currentUserIndexers = await ref.watch(currentUserIndexersProvider.future);

  if (currentUserIndexers == null) {
    throw Exception('Current user indexers are not found');
  }

  final relay = await ref.watch(relayProvider(currentUserIndexers.random).future);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserRelays.kind], authors: [pubkey], limit: 1));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    final userRelays = UserRelays.fromEventMessage(events.first);
    ref.read(nostrCacheProvider.notifier).cache(userRelays);
    return userRelays;
  }

  return null;
}

@Riverpod(keepAlive: true)
Future<UserRelays?> currentUserRelays(CurrentUserRelaysRef ref) async {
  final keyStore = await ref.watch(currentUserNostrKeyStoreProvider.future);
  if (keyStore == null) {
    return null;
  }
  return await ref.watch(userRelaysProvider(keyStore.publicKey).future);
}
