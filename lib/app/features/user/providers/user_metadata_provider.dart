// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_metadata.dart';
import 'package:ice/app/features/user/providers/current_user_indexers_provider.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_provider.g.dart';

@Riverpod(keepAlive: true)
class UsersMetadataStorage extends _$UsersMetadataStorage {
  @override
  Map<String, UserMetadata> build() {
    return {};
  }

  void storeAll(List<UserMetadata> usersMetadata) {
    state = {...state, for (final userMetadata in usersMetadata) userMetadata.pubkey: userMetadata};
  }

  void store(UserMetadata userMetadata) {
    state = {...state, userMetadata.pubkey: userMetadata};
  }

  Future<void> publish(UserMetadata userMetadata) async {
    final keyStore = await ref.read(currentUserNostrKeyStoreProvider.future);

    if (keyStore == null) {
      throw Exception('Current user keystore is null');
    }

    final userRelays = await ref.read(currentUserRelaysProvider.future);

    if (userRelays == null) {
      throw Exception('User relays are not found');
    }

    final relay = await ref.read(relayProvider(userRelays.list.random.url).future);
    final event = EventMessage.fromData(
      keyStore: keyStore,
      kind: UserMetadata.kind,
      content: userMetadata.content,
    );
    await relay.sendEvent(event);
    store(userMetadata);
  }
}

@Riverpod(keepAlive: true)
Future<UserMetadata?> userMetadata(UserMetadataRef ref, String pubkey) async {
  final userMetadata = ref.watch(usersMetadataStorageProvider.select((state) => state[pubkey]));
  if (userMetadata != null) {
    return userMetadata;
  }

  final currentUserIndexers = await ref.read(currentUserIndexersProvider.future);

  if (currentUserIndexers == null) {
    throw Exception('Current user indexers are not found');
  }

  final relay = await ref.read(relayProvider(currentUserIndexers.random).future);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserMetadata.kind], authors: [pubkey], limit: 1));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    final userMetadata = UserMetadata.fromEventMessage(events.first);
    ref.read(usersMetadataStorageProvider.notifier).store(userMetadata);
    return userMetadata;
  }

  return null;
}

@Riverpod(keepAlive: true)
Future<UserMetadata?> currentUserMetadata(CurrentUserMetadataRef ref) async {
  final currentUserNostrKey = await ref.watch(currentUserNostrKeyStoreProvider.future);
  if (currentUserNostrKey == null) {
    return null;
  }
  return ref.watch(userMetadataProvider(currentUserNostrKey.publicKey).future);
}
