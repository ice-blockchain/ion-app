// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/debug/views/debug_page.dart';
import 'package:shake_gesture/shake_gesture.dart';

class DebugShakeGesture extends ConsumerWidget {
  const DebugShakeGesture({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDebugInfo = ref.read(envProvider.notifier).get<bool>(EnvVariable.SHOW_DEBUG_INFO);

    return showDebugInfo
        ? Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => ShakeGesture(
                onShake: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<DebugPage>(
                      builder: (context) => const DebugPage(),
                    ),
                  );
                },
                child: child,
              ),
            ),
          )
        : child;
  }
}
