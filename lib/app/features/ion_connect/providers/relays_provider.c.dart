// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_auth_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_close_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_timer_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_provider.c.g.dart';

typedef RelaysState = Map<String, IonConnectRelay>;

@Riverpod(keepAlive: true)
class Relay extends _$Relay with RelayTimerMixin, RelayAuthMixin, RelayCloseMixin {
  @override
  Future<IonConnectRelay> build(String url, {bool anonymous = false}) async {
    final relay = await IonConnectRelay.connect(url);

    initializeRelayTimer(relay, ref);

    if (!anonymous) {
      unawaited(initializeAuth(relay, ref));
      initializeCloseListener(relay, ref);
    }

    return relay;
  }
}
