// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_complete_provider.g.dart';

@Riverpod(keepAlive: true)
Future<bool?> onboardingComplete(Ref ref) async {
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
