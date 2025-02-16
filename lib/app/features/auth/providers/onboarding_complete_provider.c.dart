// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/user/providers/current_user_identity_provider.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_complete_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<bool?> onboardingComplete(Ref ref) async {
  final userIsReady = ref.watch(currentPubkeySelectorProvider) != null;
  if (!userIsReady) {
    return null;
  }

  final (identity, delegation, eventSigner, userMetadata) = await (
    ref.watch(currentUserIdentityProvider.future),
    ref.watch(currentUserDelegationProvider.future),
    ref.watch(currentUserIonConnectEventSignerProvider.future),
    ref.watch(currentUserMetadataProvider.future),
  ).wait;

  return delegation != null &&
      eventSigner != null &&
      delegation.data.hasDelegateFor(pubkey: eventSigner.publicKey) &&
      identity != null &&
      (identity.ionConnectRelays?.isNotEmpty).falseOrValue &&
      userMetadata != null;
}
