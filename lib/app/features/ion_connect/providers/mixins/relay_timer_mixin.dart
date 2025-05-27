// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/timer/restartable_timer.dart';

mixin RelayTimerMixin {
  late RestartableTimer _timer;
  late StreamSubscription<RelayMessage> _messagesSubscription;
  late StreamSubscription<RelayMessage> _sentMessagesSubscription;
  late StreamSubscription<int> _subscriptionsCountSubscription;
  int? _subscribersLength;

  void initializeRelayTimer(IonConnectRelay relay, Ref ref) {
    _timer = RestartableTimer(
      const Duration(seconds: 30),
      () => _processUpdate(relay, ref.invalidateSelf),
    );

    _messagesSubscription = relay.messages.listen((_) => _timer.reset());
    _sentMessagesSubscription = relay.sentMessages.listen((_) => _timer.reset());
    _subscriptionsCountSubscription = relay.subscriptionsCountStream.listen((length) {
      _subscribersLength = length;
      _processUpdate(relay, ref.invalidateSelf);
    });

    ref.onDispose(() {
      _timer.cancel();
      _messagesSubscription.cancel();
      _sentMessagesSubscription.cancel();
      _subscriptionsCountSubscription.cancel();
    });
  }

  void _processUpdate(
    IonConnectRelay relay,
    void Function() onInvalidate,
  ) {
    if (_subscribersLength == 0 && !_timer.isActive) {
      _timer.cancel();
      onInvalidate();
    }
  }
}
