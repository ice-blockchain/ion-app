// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/logger/logger.dart';

class ProviderRebuildLogger extends ProviderObserver {
  ProviderRebuildLogger({required this.threshold});
  final int threshold;
  final Map<String, int> _rebuildCounts = {};
  Timer? _logTimer;
  
  static const _logIntervalSeconds = 5;

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
    
    // Start the timer if it's not already running
    _logTimer ??= Timer.periodic(
      const Duration(seconds: _logIntervalSeconds), 
      (_) => _logRebuildStatistics(),
    );
  }
  
  void _logRebuildStatistics() {
    if (_rebuildCounts.isEmpty) return;
    
    // Sort providers by rebuild count (descending)
    final sortedProviders = _rebuildCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Calculate total rebuilds
    final totalRebuilds = _rebuildCounts.values.fold<int>(0, (sum, count) => sum + count);
    
    // Log header
    Logger.info('===== RIVERPOD REBUILD STATISTICS =====');
    Logger.info('Total rebuilds: $totalRebuilds');
    Logger.info('Top 10 providers by rebuild count:');
    
    // Log top 10 providers
    for (var i = 0; i < sortedProviders.length && i < 10; i++) {
      final entry = sortedProviders[i];
      Logger.info('${i + 1}. ${entry.key}: ${entry.value} rebuilds');
    }
    
    Logger.info('=======================================');
  }
  
  /// Reset all rebuild statistics
  void resetStatistics() {
    _rebuildCounts.clear();
    Logger.info('Riverpod rebuild statistics have been reset');
  }
  
  /// Force log current statistics immediately
  void logStatisticsNow() {
    _logRebuildStatistics();
  }
  
  void dispose() {
    _logTimer?.cancel();
    _logTimer = null;
  }
}
