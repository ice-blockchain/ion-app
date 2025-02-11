// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';

mixin RelayDelegationMixin {
  Future<void> initializeDelegationListener(IonConnectRelay relay, Ref ref) async {
    ref.listen(
      currentUserCachedDelegationProvider,
      (previous, next) => _handleDelegationChange(previous, next, relay, ref),
    );
  }

  Future<void> _handleDelegationChange(
    AsyncValue<UserDelegationEntity?>? previous,
    AsyncValue<UserDelegationEntity?> next,
    IonConnectRelay relay,
    Ref ref,
  ) async {
    if (previous?.value == null && next.value != null) {
      final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

      if (eventSigner != null) {
        final hasDelegate = next.value?.data.hasDelegateFor(pubkey: eventSigner.publicKey) ?? false;

        if (hasDelegate) {
          await ref.read(ionConnectNotifierProvider.notifier).initRelayAuth(relay);
        }
      }
    }
  }
}
