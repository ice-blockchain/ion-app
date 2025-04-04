// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void useWakelock() {
  useEffect(() {
    WakelockPlus.enable();
    return WakelockPlus.disable;
  });
}
