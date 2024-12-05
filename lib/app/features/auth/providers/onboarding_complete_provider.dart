// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_complete_provider.g.dart';

@Riverpod(keepAlive: true)
Future<bool?> onboardingComplete(Ref ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

  if (currentIdentityKeyName == null) {
    return null;
  }

  final (identity, delegation, eventSigner, userMetadata) = await (
    ref.watch(currentUserIdentityProvider.future),
    ref.watch(currentUserDelegationProvider.future),
    ref.watch(currentUserNostrEventSignerProvider.future),
    ref.watch(currentUserMetadataProvider.future),
  ).wait;

  return delegation != null &&
      eventSigner != null &&
      delegation.data.hasDelegateFor(pubkey: eventSigner.publicKey) &&
      identity != null &&
      (identity.ionConnectRelays?.isNotEmpty).falseOrValue &&
      userMetadata != null;
}
