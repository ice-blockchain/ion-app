// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_auth_mixin.c.g.dart';

@riverpod
Completer<void> relayAuthCompleter(Ref ref, IonConnectRelay relay) {
  return Completer<void>();
}

@Riverpod(keepAlive: true)
class RelayAuthChallenge extends _$RelayAuthChallenge {
  @override
  String? build(IonConnectRelay relay) => null;

  set setChallenge(String challenge) => state = challenge;
}

//TODO:move everything related to auth from IonConnectNotifier here
//TODO:handle reauth -> reset relayAuthCompleter with a new completer without the provider rebuild (store some mutable class instance)
//TODO:make relayAuthChallengeProvider not keep alive -> same as with the relayAuthCompleter and watch here
//TODO:check errors after logout - somehow the relay gets re-created and tries to send auth, but user is not authenticated and it throws erros. Figure out WHY the relay is inited -> it should not.
//TODO:handle anonymous relays (no need to wait for completer)
mixin RelayAuthMixin {
  Future<void> initializeAuth(IonConnectRelay relay, Ref ref) async {
    final authCompleter = ref.watch(relayAuthCompleterProvider(relay));

    final authMessageSubscription = relay.messages.listen((message) {
      if (message is AuthMessage) {
        ref.read(relayAuthChallengeProvider(relay).notifier).setChallenge = message.challenge;
      }
    });

    ref.listen(
      currentUserCachedDelegationProvider,
      (previous, next) => _handleDelegationChange(previous, next, relay, ref),
    );

    try {
      await ref.read(ionConnectNotifierProvider.notifier).initRelayAuth(relay);
    } catch (error) {
      authCompleter.completeError(error);
      rethrow;
    }

    ref.onDispose(authMessageSubscription.cancel);
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
            ref.read(ionConnectNotifierProvider.notifier).sendAuthEvent(relay);
          }
        }
      });
    }
  }
}
