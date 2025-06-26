// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.r.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.r.dart';

class AppLifecycleObserver extends HookConsumerWidget {
  const AppLifecycleObserver({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnAppLifecycleStateChange((_, AppLifecycleState current) {
      ref.read(appLifecycleProvider.notifier).newState = current;

      if (current == AppLifecycleState.resumed) {
        ref.read(permissionsProvider.notifier).checkAllPermissions();
      }
    });

    return child;
  }
}
