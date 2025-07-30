// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/hooks/use_on_init.dart';

(GlobalKey key, double height) useMeasuredWidgetHeight({required bool enabled}) {
  final key = useMemoized(GlobalKey.new);
  final heightState = useState<double>(0);
  useOnInit(
    () {
      final ctx = key.currentContext;
      if (ctx != null) {
        heightState.value = ctx.size?.height ?? 0;
      }
    },
    [enabled],
  );
  return (key, heightState.value);
}
