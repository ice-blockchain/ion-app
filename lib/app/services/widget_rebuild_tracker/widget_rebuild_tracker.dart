// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/services/logger/logger.dart';

class WidgetRebuildTracker {
  WidgetRebuildTracker._();

  static final _instance = WidgetRebuildTracker._();
  static WidgetRebuildTracker get instance => _instance;

  bool _isEnabled = false;
  final Map<String, int> _rebuildCounts = {};
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _periodicTimer;

  // Configuration
  static const Duration _logInterval = Duration(seconds: 10);
  static const int _topCount = 10;

  /// Enable the widget rebuild tracker.
  void enable() {
    _isEnabled = true;
    _stopwatch.start();
    Logger.info('🔧 Widget Rebuild Tracker: ENABLED');
  }

  /// Disable the widget rebuild tracker and clear all data.
  void disable() {
    _isEnabled = false;
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _rebuildCounts.clear();
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

    _rebuildCounts[widgetName] = (_rebuildCounts[widgetName] ?? 0) + 1;

    // Initialize periodic logging on first widget rebuild
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
    if (_rebuildCounts.isEmpty) {
      return;
    }

    // Sort widgets by rebuild count in descending order
    final sortedWidgets = _rebuildCounts.entries.toList()
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

      buffer.writeln('  $emoji $rank. ${entry.key}: ${entry.value} rebuilds');
    }

    final totalRebuilds = _rebuildCounts.values.fold(0, (sum, count) => sum + count);
    buffer
      ..writeln('📊 Total rebuilds: $totalRebuilds')
      ..writeln('⏱️  Elapsed time: ${_stopwatch.elapsed}');

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

  /// Get current rebuild statistics (useful for testing or custom logging)
  Map<String, int> get rebuildCounts => Map.unmodifiable(_rebuildCounts);

  /// Check if the tracker is currently enabled
  bool get isEnabled => _isEnabled;

  /// Clear all rebuild statistics without disabling the tracker
  void clearStatistics() {
    _rebuildCounts.clear();
    _stopwatch
      ..reset()
      ..start();
    Logger.info('🔧 Widget Rebuild Tracker: Statistics cleared');
  }
}
