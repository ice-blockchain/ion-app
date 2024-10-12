// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ice/app/features/user/model/user_delegation.dart';
import 'package:ice/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ice/app/features/user/providers/user_delegation_provider.dart';
import 'package:ice/app/features/wallets/providers/main_wallet_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';
part 'onboarding_provider.freezed.dart';

@Freezed(copyWith: true, equal: true)
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    String? name,
    String? displayName,
    List<String>? languages,
    List<String>? followPubkeys,
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

  Future<void> finish() async {
    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);

    if (currentIdentityKeyName == null) {
      throw Exception('Current user is not found');
    }

    final nostrKeyStore = await ref.read(currentUserNostrKeyStoreProvider.future) ??
        await ref.read(nostrKeyStoreProvider(currentIdentityKeyName).notifier).generate();

    /// TODO:
    /// 1. Get User Relays from identity.io using `followPubkeys`
    /// 2. Generate keyStore
    /// 3. Send Nostr Delegate with keyStore from 2
    /// 3. Send Nostr MetaData with `name` and `displayName`
    /// 4. Send Nostr FollowList with `followPubkeys`
    /// 5. Send Nostr Langs with `languages`
    /// 6. Send Nostr UserRelays with values from 1
    /// 7. Clear onboarding data on success
    ///
    /// TODO: handle the case when something fails

    await _updateDelegation(nostrKeyStore: nostrKeyStore);
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
}

@Riverpod(keepAlive: true)
Future<bool?> onboardingComplete(OnboardingCompleteRef ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

  if (currentIdentityKeyName == null) {
    return null;
  }

  final (identity, delegation, nostrKeyStore) = await (
    ref.watch(currentUserIdentityProvider.future),
    ref.watch(currentUserDelegationProvider.future),
    ref.watch(currentUserNostrKeyStoreProvider.future),
  ).wait;

  return delegation != null &&
      nostrKeyStore != null &&
      delegation.hasDelegateFor(pubkey: nostrKeyStore.publicKey) &&
      identity != null &&
      identity.masterPubkey != null &&
      identity.ionConnectRelays.isNotEmpty;
}
