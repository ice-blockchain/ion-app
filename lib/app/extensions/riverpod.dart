// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

extension DebounceExtension on Ref {
  Future<void> debounce({Duration duration = const Duration(milliseconds: 300)}) {
    final completer = Completer<void>();
    final timer = Timer(duration, () {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    onDispose(() {
      timer.cancel();
      if (!completer.isCompleted) {
        completer.completeError(StateError('cancelled'));
      }
    });

    return completer.future;
  }
}
