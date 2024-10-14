// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/providers/onboarding_data_provider.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/user/model/user_delegation.dart';
import 'package:ice/app/features/user/model/user_metadata.dart';
import 'package:ice/app/features/user/model/user_relays.dart';
import 'package:ice/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ice/app/features/user/providers/user_delegation_provider.dart';
import 'package:ice/app/features/user/providers/user_metadata_provider.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:ice/app/features/wallets/providers/main_wallet_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_complete_notifier.g.dart';

@riverpod
class OnboardingCompleteNotifier extends _$OnboardingCompleteNotifier {
  @override
  FutureOr<void> build() {}

  // TODO: handle the case when something fails
  Future<void> finish() async {
    final (:name, :displayName, :languages, :followees) =
        ref.read(onboardingDataProvider.notifier).requireValues();

    final (relayUrls, nostrKeyStore) = await (
      _assignUserRelays(followees: followees),
      _generateNostrKeyStore(),
    ).wait;

    final userRelays = UserRelays(
      pubkey: nostrKeyStore.publicKey,
      list: relayUrls.map((url) => UserRelay(url: url)).toList(),
    );

    ref.read(usersRelaysStorageProvider.notifier).store(userRelays);

    await (
      _updateUserRelays(userRelays: userRelays),
      _updateMetadata(nostrKeyStore: nostrKeyStore, name: name, displayName: displayName),
      _updateLanguages(languages: languages),
      _updateFollowees(followees: followees),
      _updateDelegation(nostrKeyStore: nostrKeyStore)
    ).wait;
  }

  Future<List<String>> _assignUserRelays({required List<String> followees}) async {
    final userIdentity = await ref.read(currentUserIdentityProvider.future);
    if (userIdentity == null) {
      throw Exception('User identity is null');
    }

    if (userIdentity.ionConnectRelays.isNotEmpty) {
      return userIdentity.ionConnectRelays;
    }

    //TODO: Add identity io request here.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return [
      'wss://relay.damus.io',
      'wss://relay.damus.io',
      'wss://relay.damus.io',
    ];
  }

  Future<void> _updateUserRelays({required UserRelays userRelays}) async {
    await ref.read(usersRelaysStorageProvider.notifier).publish(userRelays);
  }

  Future<KeyStore> _generateNostrKeyStore() async {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (currentIdentityKeyName == null) {
      throw Exception('Current user is null');
    }

    final nostrKeyStore = await ref.read(currentUserNostrKeyStoreProvider.future) ??
        await ref.read(nostrKeyStoreProvider(currentIdentityKeyName).notifier).generate();
    return nostrKeyStore;
  }

  Future<void> _updateLanguages({required List<String> languages}) async {
    //TODO: impl
  }

  Future<void> _updateFollowees({required List<String> followees}) async {
    //TODO: impl
  }

  Future<void> _updateDelegation({required KeyStore nostrKeyStore}) async {
    final mainWallet = await ref.read(mainWalletProvider.future);

    if (mainWallet == null) {
      throw Exception('Main wallet is not found');
    }

    final delegation = await ref.read(currentUserDelegationProvider.future) ??
        UserDelegation(pubkey: mainWallet.signingKey.publicKey, delegates: []);

    final delegate = UserDelegate(
      pubkey: nostrKeyStore.publicKey,
      time: DateTime.now(),
      status: DelegationStatus.active,
    );

    final updatedDelegation = delegation.copyWith(
      delegates: [...delegation.delegates, delegate],
    );

    await ref.read(usersDelegationStorageProvider.notifier).publish(updatedDelegation);
  }

  Future<void> _updateMetadata({
    required KeyStore nostrKeyStore,
    required String name,
    required String displayName,
  }) async {
    final userMetadata = UserMetadata(
      pubkey: nostrKeyStore.publicKey,
      name: name,
      displayName: displayName,
    );
    await ref.read(usersMetadataStorageProvider.notifier).publish(userMetadata);
  }
}
