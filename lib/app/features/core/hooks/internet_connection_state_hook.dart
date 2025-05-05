// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

typedef ConnectivityCallback = FutureOr<void> Function(
  InternetStatus? previous,
  InternetStatus current,
);

/// Returns the current [InternetStatus] value and rebuilds the widget when it changes.
InternetStatus? useConnectivityState() {
  return use(const _InternetStatusHook(rebuildOnChange: true));
}

/// Listens to the [InternetStatus].
void useOnConnectivityStateChange(ConnectivityCallback? onStateChanged) {
  use(_InternetStatusHook(onStateChanged: onStateChanged));
}

class _InternetStatusHook extends Hook<InternetStatus?> {
  const _InternetStatusHook({
    this.rebuildOnChange = false,
    this.onStateChanged,
  }) : super();

  final bool rebuildOnChange;
  final ConnectivityCallback? onStateChanged;

  @override
  __InternetStatusState createState() => __InternetStatusState();
}

class __InternetStatusState extends HookState<InternetStatus?, _InternetStatusHook> {
  InternetStatus? _state;
  late final StreamSubscription<InternetStatus> _subscription;

  @override
  void initHook() {
    super.initHook();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      _state = status;
      if (hook.rebuildOnChange) {
        setState(() {});
      }
    });
  }

  @override
  InternetStatus? build(BuildContext context) => _state;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
