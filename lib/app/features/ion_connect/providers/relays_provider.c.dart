// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_active_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_auth_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_closed_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_timer_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_provider.c.g.dart';

typedef RelaysState = Map<String, IonConnectRelay>;

@Riverpod(keepAlive: true)
class Relay extends _$Relay
    with RelayTimerMixin, RelayAuthMixin, RelayClosedMixin, RelayActiveMixin {
  @override
  Future<IonConnectRelay> build(String url, {bool anonymous = false}) async {
    final relay = await IonConnectRelay.connect(url);

    trackRelayAsActive(relay, ref);
    initializeRelayTimer(relay, ref);
    initializeRelayClosedListener(relay, ref);

    if (!anonymous) {
      await initializeAuth(relay, ref);
    }

    ref.onDispose(relay.close);

    return relay;
  }
}
