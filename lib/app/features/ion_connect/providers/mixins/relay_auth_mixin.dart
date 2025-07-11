// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/relays/relay_auth_provider.r.dart';
import 'package:ion/app/features/user/model/user_delegation.f.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.r.dart';

mixin RelayAuthMixin {
  Future<void> initializeAuth(IonConnectRelay relay, Ref ref) async {
    ref.watch(relayAuthProvider(relay));

    await ref.read(relayAuthProvider(relay)).initRelayAuth();

    ref.listen(
      currentUserCachedDelegationProvider,
      (previous, next) => _handleDelegationChange(previous, next, relay, ref),
    );
  }

  void _handleDelegationChange(
    AsyncValue<UserDelegationEntity?>? previous,
    AsyncValue<UserDelegationEntity?> next,
    IonConnectRelay relay,
    Ref ref,
  ) {
    final prevValue = previous?.value;
    final nextValue = next.value;
    final eventSigner = ref.read(currentUserIonConnectEventSignerProvider).valueOrNull;

    if (eventSigner != null) {
      final nextHasDelegate =
          nextValue?.data.hasDelegateFor(pubkey: eventSigner.publicKey) ?? false;
      final prevHasDelegate =
          prevValue?.data.hasDelegateFor(pubkey: eventSigner.publicKey) ?? false;

      if (!prevHasDelegate && nextHasDelegate) {
        ref.read(relayAuthProvider(relay)).authenticateRelay();
      }
    }
  }
}
