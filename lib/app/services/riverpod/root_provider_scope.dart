import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/services/logger/config.dart';
import 'package:ice/app/services/riverpod/riverpod_logger.dart';

class RiverpodRootProviderScope extends StatelessWidget {
  const RiverpodRootProviderScope({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: <ProviderObserver>[
        if (LoggerConfig.riverpodLogsEnabled) RiverpodLogger(),
      ],
      child: child,
    );
  }
}
