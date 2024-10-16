// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/nostr/providers/nostr_cache.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_metadata.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserMetadata?> userMetadata(UserMetadataRef ref, String pubkey) async {
  final userMetadata = ref.watch(nostrCache<UserMetadata>(pubkey));
  if (userMetadata != null) {
    return userMetadata;
  }

  final userRelays = await ref.watch(userRelaysProvider(pubkey).future);

  if (userRelays == null) {
    throw Exception('User indexers are not found');
  }

  final relay = await ref.watch(relayProvider(userRelays.list.random.url).future);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserMetadata.kind], authors: [pubkey], limit: 1));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    final userMetadata = UserMetadata.fromEventMessage(events.first);
    ref.read(nostrCacheProvider.notifier).cache(userMetadata);
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
