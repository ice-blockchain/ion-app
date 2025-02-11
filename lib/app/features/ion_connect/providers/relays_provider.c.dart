// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_auth_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_delegation_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_init_mixin.dart';
import 'package:ion/app/features/ion_connect/providers/mixins/relay_timer_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_provider.c.g.dart';

typedef RelaysState = Map<String, IonConnectRelay>;

@Riverpod(keepAlive: true)
class Relay extends _$Relay
    with RelayTimerMixin, RelayAuthMixin, RelayInitMixin, RelayDelegationMixin {
  @override
  Future<IonConnectRelay> build(String url, {bool anonymous = false}) async {
    final relay = await IonConnectRelay.connect(url);

    initializeRelayTimer(relay, ref);

    if (!anonymous) {
      await initializeDelegationListener(relay, ref);
      initializeAuthMessageListener(relay, ref);
      await initRelay(relay, ref);
    }

    return relay;
  }
}
