// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/active_relays_provider.c.dart';

mixin RelayCloseMixin {
  StreamSubscription<void>? _subscriptions;

  void initializeCloseListener(IonConnectRelay relay, Ref ref) {
    _subscriptions = relay.onClose.listen(
      (url) {
        ref.read(activeRelaysProvider.notifier).removeRelay(url);
        _subscriptions?.cancel();
      },
    );

    ref.onDispose(() {
      _subscriptions?.cancel();
    });
  }
}
