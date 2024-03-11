import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';

class LifecycleWatcher extends ConsumerStatefulWidget {
  const LifecycleWatcher({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LifecycleWatcherWidgetState();
}

class _LifecycleWatcherWidgetState extends ConsumerState<LifecycleWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ref.read(permissionsProvider.notifier).checkAllPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
