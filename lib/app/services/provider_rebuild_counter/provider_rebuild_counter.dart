// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/logger/logger.dart';

Stopwatch _stopwatch = Stopwatch();

class ProviderRebuildLogger extends ProviderObserver {
  ProviderRebuildLogger({
    required this.threshold,
    this.logInterval = const Duration(seconds: 5),
    this.topCount = 10,
  }) {
    _stopwatch.start();
  }
  
  final int threshold;
  final Duration logInterval;
  final int topCount;
  final Map<String, int> _rebuildCounts = {};
  Timer? _periodicTimer;

  void _initializePeriodicLogging() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(logInterval, (_) {
      _logTopRebuiltProviders();
    });
  }

  void _logTopRebuiltProviders() {
    if (_rebuildCounts.isEmpty) {
      return;
    }

    // Sort providers by rebuild count in descending order
    final sortedProviders = _rebuildCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topProviders = sortedProviders.take(topCount).toList();

    if (topProviders.isEmpty) {
      return;
    }

    final buffer = StringBuffer('🔄 Top $topCount Most Rebuilt Providers:\n');
    
    for (int i = 0; i < topProviders.length; i++) {
      final entry = topProviders[i];
      final rank = i + 1;
      final emoji = _getRankEmoji(rank);
      
      buffer.writeln('  $emoji $rank. ${entry.key}: ${entry.value} rebuilds');
    }
    buffer.writeln('Total time: ${_stopwatch.elapsed}');

    Logger.info(buffer.toString());
  }

  String _getRankEmoji(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '📊';
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final key = provider.name ?? provider.runtimeType.toString();

    _rebuildCounts[key] = (_rebuildCounts[key] ?? 0) + 1;

    // Initialize periodic logging on first provider update
    if (_periodicTimer == null) {
      _initializePeriodicLogging();
    }

    if (_rebuildCounts[key]! > threshold) {
      Logger.warning(
        '[ProviderRebuildLogger] Provider "$key" rebuilt ${_rebuildCounts[key]} times! Possible circular dependency.',
      );
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    final key = provider.name ?? provider.runtimeType.toString();
    _rebuildCounts.remove(key);
  }

  void dispose() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _rebuildCounts.clear();
  }
}
