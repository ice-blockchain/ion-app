// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_delegation.dart';
import 'package:ice/app/features/user/providers/current_user_indexers_provider.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ice/app/services/ion_identity_client/mocked_ton_wallet_keystore.dart';
import 'package:ion_identity_client/ion_client.dart';
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
    final relayUrl = await ref.read(indexerPickerProvider.notifier).getNext();
    final relay = await ref.read(relayProvider(relayUrl).future);
    final tags = userDelegation.tags;
    final createdAt = DateTime.now();
    const kind = UserDelegation.kind;
    final eventId = EventMessage.calculateEventId(
      publicKey: userDelegation.pubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
    );
    // TODO: use identity ton waller signing request here when implemented
    // and add prefix to the signature with '${wallet.signingKey.scheme}_${wallet.signingKey.curve}:'
    final sig = mockedTonWalletKeystore.sign(message: eventId);
    final event = EventMessage(
      id: eventId,
      pubkey: userDelegation.pubkey,
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

  final relayUrl = await ref.read(indexerPickerProvider.notifier).getNext();
  final relay = await ref.read(relayProvider(relayUrl).future);
  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserDelegation.kind], limit: 1, p: [pubkey]));
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
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return null;
  }
  // TODO: take from walletsDataNotifierProvider when connected to ionClient
  final ionClient = await ref.read(ionApiClientProvider.future);
  final listWalletResult = await ionClient(username: currentIdentityKeyName).wallets.listWallets();
  if (listWalletResult is ListWalletsSuccess) {
    final mainWallet = listWalletResult.wallets.firstWhereOrNull((wallet) => wallet.name == 'main');
    if (mainWallet == null) {
      throw Exception('Main wallet is not found');
    }
    //TODO: take `mainWallet.signingKey.publicKey` when remote signing is implemented
    final mainWalletPubkey = mockedTonWalletKeystore.publicKey;
    return ref.watch(userDelegationProvider(mainWalletPubkey).future);
  } else {
    throw Exception(listWalletResult.toString());
  }
}
