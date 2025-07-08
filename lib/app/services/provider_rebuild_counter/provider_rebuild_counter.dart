// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/logger/logger.dart';

class ProviderRebuildLogger extends ProviderObserver {
  ProviderRebuildLogger({required this.rebuildLogInterval});
  final int rebuildLogInterval;
  final Map<String, int> _rebuildCounts = {};

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final key = _getProviderKey(provider);
    final count = _rebuildCounts[key] = (_rebuildCounts[key] ?? 0) + 1;

    if (count % rebuildLogInterval == 0) {
      Logger.warning(
        '[ProviderRebuildLogger] Provider "$key" rebuilt $count times.',
      );
    }
  }

  String _getProviderKey(ProviderBase<Object?> provider) {
    return provider.name ?? provider.runtimeType.toString();
  }
}
