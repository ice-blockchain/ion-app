// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/services/logger/logger.dart';

class WidgetRebuildTracker {
  WidgetRebuildTracker._();

  static final _instance = WidgetRebuildTracker._();
  static WidgetRebuildTracker get instance => _instance;

  bool _isEnabled = false;
  final Map<String, List<DateTime>> _rebuildTimestamps = {};
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _periodicTimer;

  static const Duration _logInterval = Duration(seconds: 10);
  static const int _topCount = 10;
  static const Duration _rapidRebuildThreshold = Duration(milliseconds: 300);

  void enable() {
    _isEnabled = true;
    _stopwatch.start();
    Logger.info('🔧 Widget Rebuild Tracker: ENABLED');
  }

  void disable() {
    _isEnabled = false;
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _rebuildTimestamps.clear();
    _stopwatch.reset();
    Logger.info('🔧 Widget Rebuild Tracker: DISABLED');
  }

  /// Track a widget rebuild. Call this from your widget's build method.
  ///
  /// Usage:
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   WidgetRebuildTracker.instance.trackRebuild('MyWidget');
  ///   // or with more context:
  ///   WidgetRebuildTracker.instance.trackRebuild('MyWidget-${widget.id}');
  ///
  ///   return YourWidgetContent();
  /// }
  /// ```
  void trackRebuild(String widgetName) {
    if (!_isEnabled) return;

    final truncatedName =
        widgetName.length > 40 ? '${widgetName.substring(0, 37)}...' : widgetName.padRight(40);
    final now = DateTime.now();
    _rebuildTimestamps.putIfAbsent(truncatedName, () => []).add(now);

    if (_periodicTimer == null) {
      _initializePeriodicLogging();
    }
  }

  void _initializePeriodicLogging() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(_logInterval, (_) {
      _logTopRebuiltWidgets();
    });
  }

  void _logTopRebuiltWidgets() {
    if (_rebuildTimestamps.isEmpty) {
      return;
    }

    // Convert timestamps to counts and sort by rebuild count in descending order
    final rebuildCounts = _rebuildTimestamps.map(
      (key, timestamps) => MapEntry(key, timestamps.length),
    );

    final sortedWidgets = rebuildCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topWidgets = sortedWidgets.take(_topCount).toList();

    if (topWidgets.isEmpty) {
      return;
    }

    final buffer = StringBuffer('🔄 Top $_topCount Most Rebuilt Widgets:\n');

    for (var i = 0; i < topWidgets.length; i++) {
      final entry = topWidgets[i];
      final rank = i + 1;
      final emoji = _getRankEmoji(rank);

      final rapidRebuildsCount = _countRapidRebuilds(entry.key);
      final rapidRebuildInfo = rapidRebuildsCount > 0
          ? ' ($rapidRebuildsCount rapid <${_rapidRebuildThreshold.inMilliseconds}ms)'
          : '';

      buffer.writeln('  $emoji $rank. ${entry.key}: ${entry.value} rebuilds$rapidRebuildInfo');
    }

    final totalRebuilds = rebuildCounts.values.fold(0, (sum, count) => sum + count);
    buffer
      ..writeln('📊 Total rebuilds: $totalRebuilds')
      ..writeln('⏱️  Elapsed time: ${_stopwatch.elapsed}');

    Logger.info(buffer.toString());
  }

  int _countRapidRebuilds(String widgetName) {
    final timestamps = _rebuildTimestamps[widgetName];
    if (timestamps == null || timestamps.length < 2) {
      return 0;
    }

    var rapidCount = 0;
    for (var i = 1; i < timestamps.length; i++) {
      final timeDiff = timestamps[i].difference(timestamps[i - 1]);
      if (timeDiff < _rapidRebuildThreshold) {
        rapidCount++;
      }
    }

    return rapidCount;
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

  Map<String, int> get rebuildCounts => _rebuildTimestamps.map(
        (key, timestamps) => MapEntry(key, timestamps.length),
      );

  List<DateTime> getWidgetTimestamps(String widgetName) {
    return List.unmodifiable(_rebuildTimestamps[widgetName] ?? []);
  }

  bool get isEnabled => _isEnabled;

  void clearStatistics() {
    _rebuildTimestamps.clear();
    _stopwatch
      ..reset()
      ..start();
    Logger.info('🔧 Widget Rebuild Tracker: Statistics cleared');
  }
}
