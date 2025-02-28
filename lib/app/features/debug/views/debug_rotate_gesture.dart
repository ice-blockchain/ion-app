// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/sensors/device_rotation_detector.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/debug/views/debug_page.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class DebugRotateGesture extends HookConsumerWidget {
  const DebugRotateGesture({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDebugInfo = ref.watch(envProvider.notifier).get<bool>(EnvVariable.SHOW_DEBUG_INFO);

    if (!showDebugInfo) return child;

    final isSheetOpen = useState(false);

    return DeviceRotationDetector(
      onRotate: () {
        if (isSheetOpen.value) {
          return;
        }

        isSheetOpen.value = true;

        HapticFeedback.vibrate();
        showSimpleBottomSheet<void>(
          context: rootNavigatorKey.currentContext!,
          child: const DebugPage(),
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) {
              isSheetOpen.value = false;
            }
          },
        );
      },
      child: child,
    );
  }
}
