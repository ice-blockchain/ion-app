// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/nostr/providers/auth_challenge_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

mixin RelayAuthMixin {
  late StreamSubscription<RelayMessage> _authMessageSubscription;

  void initializeAuthMessageListener(NostrRelay relay, Ref ref) {
    _authMessageSubscription = relay.messages.listen((message) {
      if (message is AuthMessage) {
        ref.read(authChallengeProvider(relay.url).notifier).setChallenge = message.challenge;
      }
    });
  }

  void disposeAuth() {
    _authMessageSubscription.cancel();
  }
}
