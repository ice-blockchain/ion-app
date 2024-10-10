// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_delegation.dart';
import 'package:ice/app/features/user/providers/current_user_indexers_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_delegation_provider.g.dart';

@Riverpod(keepAlive: true)
class UsersDelegationStorage extends _$UsersDelegationStorage {
  @override
  Map<String, UserDelegation> build() {
    return {};
  }

  void store(UserDelegation userDelegation) {
    state = {...state, userDelegation.pubkey: userDelegation};
  }

  Future<void> publish(UserDelegation userDelegation) async {
    throw Exception('Not implemented yet');
  }
}

@Riverpod(keepAlive: true)
Future<UserDelegation?> userDelegation(UserDelegationRef ref, String pubkey) async {
  final userDelegation = ref.watch(usersDelegationStorageProvider.select((state) => state[pubkey]));
  if (userDelegation != null) {
    return userDelegation;
  }

  final relayUrl = await ref.read(indexerPickerProvider.notifier).getNext();
  final relay = await ref.read(relayProvider(relayUrl).future);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [10100], limit: 1, p: [pubkey]));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    final userDelegation = UserDelegation.fromEventMessage(events.first);
    ref.read(usersDelegationStorageProvider.notifier).store(userDelegation);
    return userDelegation;
  }

  return null;
}

@riverpod
AsyncValue<UserDelegation?> currentUserDelegation(CurrentUserDelegationRef ref) {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return const AsyncData(null);
  }
  return ref.watch(userDelegationProvider(currentIdentityKeyName));
}
