// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/active_relays_provider.r.dart';

mixin RelayActiveMixin {
  void trackRelayAsActive(IonConnectRelay relay, Ref ref) {
    ref.read(activeRelaysProvider.notifier).addRelay(relay.url);
    ref.onDispose(() {
      ref.read(activeRelaysProvider.notifier).removeRelay(relay.url);
    });
  }
}
