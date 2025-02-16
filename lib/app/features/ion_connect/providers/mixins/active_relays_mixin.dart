// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/active_relays_provider.c.dart';

mixin ActiveRelaysMixin {
  StreamSubscription<void>? _subscriptions;

  void initializeActiveRelaysListener(IonConnectRelay relay, Ref ref) {
    _subscriptions = relay.onClose.listen(
      (url) {
        _subscriptions?.cancel();
        ref.invalidateSelf();
      },
    );

    ref.onDispose(() {
      ref.read(activeRelaysProvider.notifier).removeRelay(relay.url);
      _subscriptions?.cancel();
    });
  }
}
