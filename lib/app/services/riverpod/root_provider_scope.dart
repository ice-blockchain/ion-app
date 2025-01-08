// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/riverpod/riverpod_logger.dart';

const _riverpodLoggerEnabled = false;

class RiverpodRootProviderScope extends ConsumerWidget {
  const RiverpodRootProviderScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      observers: <ProviderObserver>[
        if (_riverpodLoggerEnabled) RiverpodLogger(),
      ],
      child: child,
    );
  }
}
