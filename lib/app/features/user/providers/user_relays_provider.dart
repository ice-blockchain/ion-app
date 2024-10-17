// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/nostr/model/action_source.dart';
import 'package:ice/app/features/nostr/providers/nostr_cache.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ice/app/features/user/model/user_relays.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_relays_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserRelays?> userRelays(UserRelaysRef ref, String pubkey) async {
  final userRelays = ref.watch(nostrCache<UserRelays>(pubkey));
  if (userRelays != null) {
    return userRelays;
  }

  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserRelays.kind], authors: [pubkey], limit: 1));
  final event = await ref.read(nostrNotifierProvider.notifier).requestOne(
        requestMessage,
        actionSource: const ActionSourceIndexers(),
      );
  if (event != null) {
    final userRelays = UserRelays.fromEventMessage(event);
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
