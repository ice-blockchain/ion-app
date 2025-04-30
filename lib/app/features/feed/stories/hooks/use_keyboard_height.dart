// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

double _logicalInset(FlutterView view) => view.viewInsets.bottom / view.devicePixelRatio;

double useKeyboardHeight() {
  final dispatcher = WidgetsBinding.instance.platformDispatcher;
  final height = useState<double>(_logicalInset(dispatcher.views.first));

  useEffect(
    () {
      final obs = _MetricsObserver(
        onMetricsChanged: () => height.value = _logicalInset(dispatcher.views.first),
      );

      WidgetsBinding.instance.addObserver(obs);
      return () => WidgetsBinding.instance.removeObserver(obs);
    },
    [dispatcher],
  );

  return height.value;
}

class _MetricsObserver with WidgetsBindingObserver {
  _MetricsObserver({required this.onMetricsChanged});
  final VoidCallback onMetricsChanged;

  @override
  void didChangeMetrics() => onMetricsChanged();
}
