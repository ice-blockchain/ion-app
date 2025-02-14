// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';

mixin RelayInitMixin {
  Future<void> initRelay(IonConnectRelay relay, Ref ref) async {
    final completer = Completer<void>();

    try {
      await ref.read(ionConnectNotifierProvider.notifier).initRelayAuth(
            relay,
            onAuthSuccess: completer.complete,
          );
    } catch (e) {
      completer.completeError(e);
      rethrow;
    }
  }
}
