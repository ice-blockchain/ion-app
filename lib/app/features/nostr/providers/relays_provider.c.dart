// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/utils/restartable_timer.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_provider.c.g.dart';

typedef RelaysState = Map<String, NostrRelay>;

@Riverpod(keepAlive: true)
class RelayNotifier extends _$RelayNotifier {
  late RestartableTimer _timer;
  late StreamSubscription<RelayMessage> _messagesSubscription;
  late StreamSubscription<int> _subscriptionsCountSubscription;
  bool _timerFinished = false;
  int? _subscribersLength;

  @override
  Future<NostrRelay> build(String url) async {
    final relay = await NostrRelay.connect(url);

    // Close a connection if ALL of the following happens:
    // 1. Has no active subscriptions
    // 2. it has been at least 30s since last message from the relay was received
    _initializeTimer(relay);
    _messagesSubscription = relay.messages.listen((_) => _resetTimer());
    _subscriptionsCountSubscription = relay.subscriptionsCountStream.listen((length) {
      _subscribersLength = length;
      _processUpdate(relay);
    });

    ref.onDispose(_dispose);

    return relay;
  }

  void _initializeTimer(NostrRelay relay) {
    _timer = RestartableTimer(const Duration(seconds: 30), () {
      _timerFinished = true;
      _processUpdate(relay);
    });
  }

  void _resetTimer() {
    _timerFinished = false;
    _timer.reset();
  }

  void _processUpdate(NostrRelay relay) {
    if (_subscribersLength == 0 && _timerFinished) {
      _timer.cancel();
      relay.close();
      ref.invalidateSelf();
    }
  }

  void _dispose() {
    _timer.cancel();
    _messagesSubscription.cancel();
    _subscriptionsCountSubscription.cancel();
  }
}
