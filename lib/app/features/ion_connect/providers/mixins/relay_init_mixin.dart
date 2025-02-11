// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/active_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';

mixin RelayInitMixin {
  final _initCompleters = <String, Completer<void>>{};
  final _subscriptions = <String, StreamSubscription<void>>{};

  Future<void> initRelay(IonConnectRelay relay, Ref ref) async {
    if (_initCompleters.containsKey(relay.url)) {
      await _initCompleters[relay.url]!.future;
      return;
    }

    final completer = Completer<void>();
    _initCompleters[relay.url] = completer;

    try {
      await ref.read(ionConnectNotifierProvider.notifier).initRelayAuth(relay);

      _subscriptions[relay.url] = relay.onClose.listen(
        (url) {
          ref.read(activeRelaysProvider.notifier).removeRelay(url);
          _subscriptions.remove(url)?.cancel();
        },
      );

      completer.complete();
    } catch (e) {
      completer.completeError(e);
      _initCompleters.remove(relay.url);
      rethrow;
    }

    ref.onDispose(() {
      _initCompleters.remove(relay.url);
    });
  }
}
