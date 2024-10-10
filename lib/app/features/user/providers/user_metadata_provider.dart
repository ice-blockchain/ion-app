// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_metadata.dart';
import 'package:ice/app/features/user/providers/current_user_indexers_provider.dart';
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
    throw Exception('Not implemented yet');
  }
}

@Riverpod(keepAlive: true)
Future<UserMetadata?> userMetadata(UserMetadataRef ref, String pubkey) async {
  final userMetadata = ref.watch(usersMetadataStorageProvider.select((state) => state[pubkey]));
  if (userMetadata != null) {
    return userMetadata;
  }

  final relayUrl = await ref.read(indexerPickerProvider.notifier).getNext();
  final relay = await ref.read(relayProvider(relayUrl).future);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [0], authors: [pubkey], limit: 1));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    final userMetadata = UserMetadata.fromEventMessage(events.first);
    ref.read(usersMetadataStorageProvider.notifier).store(userMetadata);
    return userMetadata;
  }

  return null;
}

@riverpod
Future<UserMetadata?> currentUserMetadata(CurrentUserMetadataRef ref) async {
  final currentUserId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
  if (currentUserId.isEmpty) {
    return null;
  }
  return ref.watch(userMetadataProvider(currentUserId).future);
}
