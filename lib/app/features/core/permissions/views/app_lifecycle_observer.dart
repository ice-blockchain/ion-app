import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';

class AppLifecycleObserver extends HookConsumerWidget {
  const AppLifecycleObserver({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionsNotifier = ref.watch(permissionsProvider.notifier);

    useEffect(
      () {
        final observer = _LifecycleObserver(
          onResume: permissionsNotifier.checkAllPermissions,
        );
        WidgetsBinding.instance.addObserver(observer);

        return () {
          WidgetsBinding.instance.removeObserver(observer);
        };
      },
      [],
    );

    return child;
  }
}

class _LifecycleObserver extends WidgetsBindingObserver {
  _LifecycleObserver({required this.onResume});

  final VoidCallback onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}
