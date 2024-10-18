// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_complete_provider.g.dart';

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
