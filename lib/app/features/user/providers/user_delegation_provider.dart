// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/model/user_delegation.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:ice/app/features/wallets/providers/main_wallet_provider.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
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
}

@Riverpod(keepAlive: true)
Future<UserDelegation?> userDelegation(UserDelegationRef ref, String pubkey) async {
  final userDelegation = ref.watch(usersDelegationStorageProvider.select((state) => state[pubkey]));
  if (userDelegation != null) {
    return userDelegation;
  }

  final userRelays = await ref.watch(currentUserRelaysProvider.future);

  if (userRelays == null) {
    return null;
  }

  final relay = await ref.watch(relayProvider(userRelays.list.random.url).future);
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

@riverpod
class UserDelegationManager extends _$UserDelegationManager {
  @override
  FutureOr<void> build() {}

  Future<UserDelegation> buildCurrentUserDelegationWith({required String pubkey}) async {
    final mainWallet = (await ref.read(mainWalletProvider.future))!;

    final delegation = (await ref.read(currentUserDelegationProvider.future)) ??
        UserDelegation(
          pubkey: mainWallet.signingKey.publicKey,
          delegates: [],
        );

    return delegation.copyWith(
      delegates: [
        ...delegation.delegates,
        UserDelegate(
          pubkey: pubkey,
          time: DateTime.now(),
          status: DelegationStatus.active,
        ),
      ],
    );
  }

  Future<EventMessage> buildDelegationEventFrom(UserDelegation userDelegation) async {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider)!;
    final mainWallet = (await ref.read(mainWalletProvider.future))!;
    final ionClient = await ref.read(ionApiClientProvider.future);

    final tags = userDelegation.tags;
    final createdAt = DateTime.now();
    const kind = UserDelegation.kind;
    final masterPubkey = mainWallet.signingKey.publicKey;

    final eventId = EventMessage.calculateEventId(
      publicKey: masterPubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
    );

    final signResponse = await ionClient(username: currentIdentityKeyName)
        .wallets
        .generateSignature(mainWallet.id, eventId);

    final signaturePrefix =
        '${mainWallet.signingKey.scheme}/${mainWallet.signingKey.curve}'.toLowerCase();
    final signatureBody =
        '${signResponse.signature['r']}${signResponse.signature['s']}'.replaceAll('0x', '');
    final signature = '$signaturePrefix:$signatureBody';

    return EventMessage(
      id: eventId,
      pubkey: masterPubkey,
      createdAt: createdAt,
      kind: kind,
      tags: tags,
      content: '',
      sig: signature,
    );
  }
}
