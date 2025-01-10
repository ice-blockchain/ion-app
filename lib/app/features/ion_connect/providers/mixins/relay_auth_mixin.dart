// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/auth_challenge_provider.c.dart';

mixin RelayAuthMixin {
  late StreamSubscription<RelayMessage> _authMessageSubscription;

  void initializeAuthMessageListener(IonConnectRelay relay, Ref ref) {
    _authMessageSubscription = relay.messages.listen((message) {
      if (message is AuthMessage) {
        ref.read(authChallengeProvider(relay.url).notifier).setChallenge = message.challenge;
      }
    });

    ref.onDispose(
      () => _authMessageSubscription.cancel(),
    );
  }
}
