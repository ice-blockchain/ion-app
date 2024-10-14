// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_delegation.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:ice/app/features/wallets/providers/main_wallet_provider.dart';
import 'package:ice/app/services/ion_identity_client/mocked_ton_wallet_keystore.dart';
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
    final mainWallet = await ref.read(mainWalletProvider.future);

    if (mainWallet == null) {
      throw Exception('Current user main wallet is null');
    }

    if (mainWallet.signingKey.publicKey != userDelegation.pubkey) {
      throw Exception(
        'Published user delegation event should have the same pubkey as the current user main wallet',
      );
    }

    final userRelays = await ref.read(currentUserRelaysProvider.future);

    if (userRelays == null) {
      throw Exception('User relays are not found');
    }

    final relay = await ref.read(relayProvider(userRelays.list.random.url).future);
    final tags = userDelegation.tags;
    final createdAt = DateTime.now();
    const kind = UserDelegation.kind;
    final pubkey = mainWallet.signingKey.publicKey;
    final eventId = EventMessage.calculateEventId(
      publicKey: pubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
    );
    // TODO: use identity ton waller signing request here when implemented
    // and add prefix to the signature with '${wallet.signingKey.scheme}/${wallet.signingKey.curve}:'
    final sig = mockedTonWalletKeystore.sign(message: eventId);
    final event = EventMessage(
      id: eventId,
      pubkey: pubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
      sig: sig,
    );
    await relay.sendEvent(event);
    store(userDelegation);
  }
}

@Riverpod(keepAlive: true)
Future<UserDelegation?> userDelegation(UserDelegationRef ref, String pubkey) async {
  final userDelegation = ref.watch(usersDelegationStorageProvider.select((state) => state[pubkey]));
  if (userDelegation != null) {
    return userDelegation;
  }

  final userRelays = await ref.read(currentUserRelaysProvider.future);

  if (userRelays == null) {
    throw Exception('User relays are not found');
  }

  final relay = await ref.read(relayProvider(userRelays.list.random.url).future);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserDelegation.kind], limit: 1, authors: [pubkey]));
  final events = await requestEvents(requestMessage, relay);

  if (events.isNotEmpty) {
    final userDelegation = UserDelegation.fromEventMessage(events.first);
    ref.read(usersDelegationStorageProvider.notifier).store(userDelegation);
    return userDelegation;
  }

  return null;
}

@Riverpod(keepAlive: true)
Future<UserDelegation?> currentUserDelegation(CurrentUserDelegationRef ref) async {
  final mainWallet = await ref.watch(mainWalletProvider.future);
  if (mainWallet == null) {
    return null;
  }
  return ref.watch(userDelegationProvider(mainWallet.signingKey.publicKey).future);
}
