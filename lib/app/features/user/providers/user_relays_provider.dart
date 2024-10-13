// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_relays.dart';
import 'package:ice/app/features/user/providers/current_user_indexers_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_relays_provider.g.dart';

@Riverpod(keepAlive: true)
class UsersRelaysStorage extends _$UsersRelaysStorage {
  @override
  Map<String, UserRelays> build() {
    return {};
  }

  void store(UserRelays userRelays) {
    state = {...state, userRelays.pubkey: userRelays};
  }

  Future<void> publish(UserRelays userRelays) async {
    final keyStore = await ref.read(currentUserNostrKeyStoreProvider.future);

    if (keyStore == null) {
      throw Exception('Current user keystore is null');
    }

    final relayUrl = await ref.read(indexerPickerProvider.notifier).getNext();
    final relay = await ref.read(relayProvider(relayUrl).future);
    final event = EventMessage.fromData(
      keyStore: keyStore,
      kind: UserRelays.kind,
      content: '',
      tags: userRelays.tags,
    );
    await relay.sendEvent(event);
    store(userRelays);
  }
}

@Riverpod(keepAlive: true)
Future<UserRelays?> userRelays(UserRelaysRef ref, String pubkey) async {
  final userRelays = ref.watch(usersRelaysStorageProvider.select((state) => state[pubkey]));
  if (userRelays != null) {
    return userRelays;
  }

  final relayUrl = await ref.read(indexerPickerProvider.notifier).getNext();
  final relay = await ref.read(relayProvider(relayUrl).future);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserRelays.kind], p: [pubkey], limit: 1));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    final userRelays = UserRelays.fromEventMessage(events.first);
    ref.read(usersRelaysStorageProvider.notifier).store(userRelays);
    return userRelays;
  }

  return null;
}

@riverpod
Future<UserRelays?> currentUserRelays(CurrentUserRelaysRef ref) async {
  final currentUserId = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUserId == null) {
    return null;
  }
  return ref.watch(userRelaysProvider(currentUserId).future);
}
