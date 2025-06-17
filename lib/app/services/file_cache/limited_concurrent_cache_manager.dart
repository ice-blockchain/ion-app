import 'dart:async';
import 'dart:collection';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:synchronized/synchronized.dart';

/// A cache manager that limits the number of concurrent downloads
class LimitedConcurrentCacheManager extends CacheManager {
  LimitedConcurrentCacheManager(
    super.config, {
    this.maxConcurrentDownloads = 3,
    this.downloadTimeout = const Duration(minutes: 5),
  });

  final int maxConcurrentDownloads;
  final Duration downloadTimeout;
  final _downloadQueue = Queue<String>();
  final _downloadCompleters = <String, List<Completer<void>>>{};
  final _activeDownloads = <String>{};
  final _lock = Lock();

  /// Get the number of queued downloads
  int get queuedDownloadsCount => _downloadQueue.length;

  /// Get the number of active downloads
  int get activeDownloadsCount => _activeDownloads.length;

  /// Cancel a queued download
  Future<void> cancelDownload(String key) async {
    await _lock.synchronized(() async {
      final completers = _downloadCompleters[key];
      if (completers != null) {
        for (final completer in completers) {
          if (!completer.isCompleted) {
            completer.completeError('Download cancelled');
          }
        }
      }
      _downloadCompleters.remove(key);
      _downloadQueue.remove(key);
    });
  }

  /// Cancel all queued downloads
  Future<void> cancelAllQueuedDownloads() async {
    await _lock.synchronized(() async {
      final keys = _downloadQueue.toList();
      for (final key in keys) {
        final completers = _downloadCompleters[key];
        if (completers != null) {
          for (final completer in completers) {
            if (!completer.isCompleted) {
              completer.completeError('All downloads cancelled');
            }
          }
        }
      }
      _downloadCompleters.clear();
      _downloadQueue.clear();
    });
  }

  @override
  Future<FileInfo> downloadFile(
    String url, {
    String? key,
    Map<String, String>? authHeaders,
    bool force = false,
  }) async {
    final downloadKey = key ?? url;

    return _lock.synchronized(() async {
      // Check if download is already in progress
      if (_activeDownloads.contains(downloadKey)) {
        // Wait for the existing download to complete
        final completer = Completer<void>();
        _downloadCompleters.putIfAbsent(downloadKey, () => <Completer<void>>[]).add(completer);

        try {
          await completer.future.timeout(downloadTimeout);
          // Try to get from cache first
          final cachedFile = await getFileFromCache(downloadKey);
          if (cachedFile != null) {
            return cachedFile;
          }
        } on TimeoutException {
          _removeCompleter(downloadKey, completer);
          throw TimeoutException('Download timeout', downloadTimeout);
        } catch (e) {
          _removeCompleter(downloadKey, completer);
          rethrow;
        }
      }

      // Wait for a slot if we're at the limit
      if (_activeDownloads.length >= maxConcurrentDownloads) {
        final completer = Completer<void>();
        _downloadCompleters.putIfAbsent(downloadKey, () => <Completer<void>>[]).add(completer);
        _downloadQueue.add(downloadKey);

        try {
          await completer.future.timeout(downloadTimeout);
        } on TimeoutException {
          _removeCompleter(downloadKey, completer);
          _downloadQueue.remove(downloadKey);
          throw TimeoutException('Queue timeout', downloadTimeout);
        } catch (e) {
          _removeCompleter(downloadKey, completer);
          _downloadQueue.remove(downloadKey);
          rethrow;
        }
      }

      try {
        _activeDownloads.add(downloadKey);
        return await super
            .downloadFile(
              url,
              key: downloadKey,
              authHeaders: authHeaders,
              force: force,
            )
            .timeout(downloadTimeout);
      } on TimeoutException {
        throw TimeoutException('Download timeout', downloadTimeout);
      } finally {
        _activeDownloads.remove(downloadKey);

        // Notify all waiters for this key
        _completeAllWaiters(downloadKey);

        // Release next waiting download from queue (FIFO)
        _releaseNextDownload();
      }
    });
  }

  void _removeCompleter(String key, Completer<void> completer) {
    final completers = _downloadCompleters[key];
    if (completers != null) {
      completers.remove(completer);
      if (completers.isEmpty) {
        _downloadCompleters.remove(key);
      }
    }
  }

  void _completeAllWaiters(String key) {
    final completers = _downloadCompleters[key];
    if (completers != null) {
      for (final completer in completers) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      _downloadCompleters.remove(key);
    }
  }

  void _releaseNextDownload() {
    if (_downloadQueue.isNotEmpty) {
      final nextKey = _downloadQueue.removeFirst();
      final completers = _downloadCompleters[nextKey];
      if (completers != null && completers.isNotEmpty) {
        final completer = completers.removeAt(0);
        if (!completer.isCompleted) {
          completer.complete();
        }
        if (completers.isEmpty) {
          _downloadCompleters.remove(nextKey);
        }
      }
    }
  }

  @override
  Future<void> dispose() async {
    await cancelAllQueuedDownloads();
    await super.dispose();
  }
}
