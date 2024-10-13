// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/user/model/user_delegation.dart';
import 'package:ice/app/features/user/model/user_identity.dart';
import 'package:ice/app/features/user/model/user_metadata.dart';
import 'package:ice/app/features/user/model/user_relays.dart';
import 'package:ice/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ice/app/features/user/providers/user_delegation_provider.dart';
import 'package:ice/app/features/user/providers/user_metadata_provider.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
import 'package:ice/app/features/wallets/providers/main_wallet_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_data_provider.freezed.dart';
part 'onboarding_data_provider.g.dart';

@Freezed(copyWith: true, equal: true)
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    String? name,
    String? displayName,
    List<String>? languages,
    List<String>? followees,
  }) = _OnboardingState;
}

@Riverpod(keepAlive: true)
class OnboardingData extends _$OnboardingData {
  @override
  OnboardingState? build() {
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (currentIdentityKeyName == null) {
      return null;
    }

    //TODO: add peristance per user + read on init

    return const OnboardingState();
  }

  set name(String name) {
    state = state?.copyWith(name: name);
  }

  set displayName(String displayName) {
    state = state?.copyWith(displayName: displayName);
  }

  set languages(List<String> languages) {
    state = state?.copyWith(languages: languages);
  }

  set followees(List<String> followees) {
    state = state?.copyWith(followees: followees);
  }

  ({String name, String displayName, List<String> languages, List<String> followees})
      requireValues() {
    final data = state;

    if (data == null) throw Exception('OnboardingState is empty');

    final OnboardingState(:name, :displayName, :languages, :followees) = data;

    if (name == null) {
      throw Exception('OnboardingState.name is empty');
    }
    if (displayName == null) {
      throw Exception('OnboardingState.displayName is empty');
    }
    if (languages == null || languages.isEmpty) {
      throw Exception('OnboardingState.languages is empty');
    }
    if (followees == null || followees.isEmpty) {
      throw Exception('OnboardingState.followees is empty');
    }
    return (name: name, displayName: displayName, languages: languages, followees: followees);
  }

  // TODO: handle the case when something fails
  Future<void> finish() async {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (currentIdentityKeyName == null) {
      throw Exception('Current user is null');
    }

    final userIdentity = await ref.read(currentUserIdentityProvider.future);
    if (userIdentity == null) {
      throw Exception('User identity is null');
    }

    final (:name, :displayName, :languages, :followees) = requireValues();

    final relayUrls = await _assignUserRelays(userIdentity: userIdentity, followees: followees);
    final nostrKeyStore = await _generateNostrKeyStore(identityKeyName: currentIdentityKeyName);
    await _updateUserRelays(nostrKeyStore: nostrKeyStore, relayUrls: relayUrls);
    await _updateMetadata(nostrKeyStore: nostrKeyStore, name: name, displayName: displayName);
    await _updateLanguages(languages: languages);
    await _updateFollowees(followees: followees);
    await _updateDelegation(nostrKeyStore: nostrKeyStore);
  }

  Future<List<String>> _assignUserRelays({
    required UserIdentity userIdentity,
    required List<String> followees,
  }) async {
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

  Future<void> _updateUserRelays({
    required KeyStore nostrKeyStore,
    required List<String> relayUrls,
  }) async {
    final userRelays = UserRelays(
      pubkey: nostrKeyStore.publicKey,
      list: relayUrls.map((url) => UserRelay(url: url, read: true, write: true)).toList(),
    );
    await ref.read(usersRelaysStorageProvider.notifier).publish(userRelays);
  }

  Future<KeyStore> _generateNostrKeyStore({required String identityKeyName}) async {
    final nostrKeyStore = await ref.read(currentUserNostrKeyStoreProvider.future) ??
        await ref.read(nostrKeyStoreProvider(identityKeyName).notifier).generate();
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
