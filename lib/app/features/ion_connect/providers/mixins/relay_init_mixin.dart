import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';

mixin RelayInitMixin {
  final _initializationCompleters = <String, Completer<void>>{};

  Future<void> initRelay(IonConnectRelay relay, Ref ref) async {
    if (_initializationCompleters.containsKey(relay.url)) {
      await _initializationCompleters[relay.url]!.future;
      return;
    }

    final completer = Completer<void>();
    _initializationCompleters[relay.url] = completer;

    try {
      final signedAuthEvent = await ref.read(ionConnectNotifierProvider.notifier).createAuthEvent(
            challenge: 'init',
            relayUrl: Uri.parse(relay.url).toString(),
          );

      await ref.read(ionConnectNotifierProvider.notifier).sendEvent(
            signedAuthEvent,
            relay: relay,
            cache: false,
          );

      completer.complete();
    } catch (e) {
      completer.completeError(e);
      _initializationCompleters.remove(relay.url);
      rethrow;
    }

    ref.onDispose(() {
      _initializationCompleters.remove(relay.url);
    });
  }
}
