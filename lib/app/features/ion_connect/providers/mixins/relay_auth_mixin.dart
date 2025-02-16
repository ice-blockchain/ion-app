// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_auth_provider.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';

mixin RelayAuthMixin {
  Future<void> initializeAuth(IonConnectRelay relay, Ref ref) async {
    ref
      ..watch(relayAuthProvider(relay))
      ..listen(
        currentUserCachedDelegationProvider,
        (previous, next) => _handleDelegationChange(previous, next, relay, ref),
      );

    await ref.read(relayAuthProvider(relay).notifier).initRelayAuth();
  }

  void _handleDelegationChange(
    AsyncValue<UserDelegationEntity?>? previous,
    AsyncValue<UserDelegationEntity?> next,
    IonConnectRelay relay,
    Ref ref,
  ) {
    if (previous?.value == null && next.value != null) {
      ref.read(currentUserIonConnectEventSignerProvider.future).then((eventSigner) {
        if (eventSigner != null) {
          final hasDelegate =
              next.value?.data.hasDelegateFor(pubkey: eventSigner.publicKey) ?? false;

          if (hasDelegate) {
            ref.read(relayAuthProvider(relay).notifier).authenticateRelay();
          }
        }
      });
    }
  }
}
