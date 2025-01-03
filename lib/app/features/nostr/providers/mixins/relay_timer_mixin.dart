// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/timer/restartable_timer.dart';
import 'package:nostr_dart/nostr_dart.dart';

mixin RelayTimerMixin {
  late RestartableTimer _timer;
  late StreamSubscription<RelayMessage> _messagesSubscription;
  late StreamSubscription<int> _subscriptionsCountSubscription;
  int? _subscribersLength;

  void initializeRelayTimer(NostrRelay relay, Ref ref) {
    _timer = RestartableTimer(
      const Duration(seconds: 30),
      () => _processUpdate(relay, ref.invalidateSelf),
    );

    _messagesSubscription = relay.messages.listen((_) => _timer.reset());
    _subscriptionsCountSubscription = relay.subscriptionsCountStream.listen((length) {
      _subscribersLength = length;
      _processUpdate(relay, ref.invalidateSelf);
    });

    ref.onDispose(() {
      _timer.cancel();
      _messagesSubscription.cancel();
      _subscriptionsCountSubscription.cancel();
    });
  }

  void _processUpdate(NostrRelay relay, void Function() onInvalidate) {
    if (_subscribersLength == 0 && !_timer.isActive) {
      _timer.cancel();
      relay.close();
      onInvalidate();
    }
  }
}
