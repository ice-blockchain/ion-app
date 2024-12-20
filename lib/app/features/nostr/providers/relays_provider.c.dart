// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/nostr/providers/mixins/relay_auth_mixin.dart';
import 'package:ion/app/features/nostr/providers/mixins/relay_timer_mixin.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_provider.c.g.dart';

typedef RelaysState = Map<String, NostrRelay>;

@Riverpod(keepAlive: true)
class Relay extends _$Relay with RelayTimerMixin, RelayAuthMixin {
  @override
  Future<NostrRelay> build(String url) async {
    final relay = await NostrRelay.connect(url);

    initializeRelayTimer(relay, ref);
    initializeAuthMessageListener(relay, ref);

    return relay;
  }
}
