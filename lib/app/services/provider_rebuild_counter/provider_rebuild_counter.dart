// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/logger/logger.dart';

class ProviderRebuildLogger extends ProviderObserver {
  ProviderRebuildLogger({required this.threshold});
  final int threshold;
  final Map<String, int> _rebuildCounts = {};

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final key = provider.name ?? provider.runtimeType.toString();

    _rebuildCounts[key] = (_rebuildCounts[key] ?? 0) + 1;

    if (_rebuildCounts[key]! > threshold) {
      Logger.warning(
        '[ProviderRebuildLogger] Provider "$key" rebuilt ${_rebuildCounts[key]} times! Possible circular dependency.',
      );
    }
  }
}
