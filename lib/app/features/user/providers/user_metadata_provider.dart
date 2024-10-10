// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/constants.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_metadata.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_provider.g.dart';

@Riverpod(keepAlive: true)
class UserMetadataStorage extends _$UserMetadataStorage {
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
  final userMetadata = ref.watch(userMetadataStorageProvider.select((state) => state[pubkey]));
  if (userMetadata != null) {
    return userMetadata;
  }

  final relay = await ref.read(relaysProvider.notifier).getOrCreate(mainRelay);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [0], authors: [pubkey], limit: 1));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    final userMetadata = UserMetadata.fromEventMessage(events.first);
    ref.read(userMetadataStorageProvider.notifier).store(userMetadata);
    return userMetadata;
  }

  return null;
}

@riverpod
AsyncValue<UserMetadata?> currentUserMetadata(CurrentUserMetadataRef ref) {
  final currentUserId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';
  if (currentUserId.isEmpty) {
    return const AsyncData(null);
  }
  return ref.watch(userMetadataProvider(currentUserId));
}
