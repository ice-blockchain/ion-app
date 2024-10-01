// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';

class LifecycleWatcher extends HookConsumerWidget {
  const LifecycleWatcher({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnAppLifecycleStateChange((
      _,
      AppLifecycleState current,
    ) {
      if (current == AppLifecycleState.resumed) {
        ref.read(permissionsProvider.notifier).checkAllPermissions();
      }
    });

    return child;
  }
}
