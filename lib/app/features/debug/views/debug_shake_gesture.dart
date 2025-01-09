// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/debug/views/debug_page.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:shake_gesture/shake_gesture.dart';

class DebugShakeGesture extends HookConsumerWidget {
  const DebugShakeGesture({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDebugInfo = ref.watch(envProvider.notifier).get<bool>(EnvVariable.SHOW_DEBUG_INFO);

    if (!showDebugInfo) return child;

    final isSheetOpen = useState(false);

    return Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => ShakeGesture(
          onShake: () {
            if (isSheetOpen.value) return;

            isSheetOpen.value = true;
            showSimpleBottomSheet<void>(
              context: context,
              child: const DebugPage(),
              onPopInvokedWithResult: (didPop, _) {
                if (didPop) {
                  isSheetOpen.value = false;
                }
              },
            );
          },
          child: child,
        ),
      ),
    );
  }
}
