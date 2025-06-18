// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:collection';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A generic cache for provider values to reduce rebuilds
class ProviderCache<K, V> {
  final Map<K, V> _cache = {};
  final Duration? _maxAge;
  final Map<K, DateTime> _timestamps = {};

  /// Creates a new provider cache with an optional max age
  ProviderCache({Duration? maxAge}) : _maxAge = maxAge;

  /// Get a value from the cache
  V? get(K key) {
    if (!_cache.containsKey(key)) return null;
    
    // Check expiration if maxAge is set
    if (_maxAge != null) {
      final timestamp = _timestamps[key];
      if (timestamp != null && 
          DateTime.now().difference(timestamp) > _maxAge) {
        // Expired
        _cache.remove(key);
        _timestamps.remove(key);
        return null;
      }
    }
    
    return _cache[key];
  }

  /// Store a value in the cache
  void put(K key, V value) {
    _cache[key] = value;
    _timestamps[key] = DateTime.now();
  }

  /// Remove a value from the cache
  void remove(K key) {
    _cache.remove(key);
    _timestamps.remove(key);
  }

  /// Clear the entire cache
  void clear() {
    _cache.clear();
    _timestamps.clear();
  }

  /// Check if the cache contains a key
  bool containsKey(K key) => _cache.containsKey(key);

  /// Get all values in the cache
  Map<K, V> get values => Map.unmodifiable(_cache);
}

/// A batch update manager to reduce the frequency of state updates
class BatchUpdateManager<K, V> {
  final Map<K, V> _pendingUpdates = {};
  Timer? _batchUpdateTimer;
  final Duration _batchInterval;
  final void Function(Map<K, V> updates) _onBatchComplete;

  /// Creates a new batch update manager
  BatchUpdateManager({
    required Duration batchInterval,
    required void Function(Map<K, V> updates) onBatchComplete,
  })  : _batchInterval = batchInterval,
        _onBatchComplete = onBatchComplete;

  /// Queue an update to be processed in the next batch
  void queueUpdate(K key, V value) {
    _pendingUpdates[key] = value;
    _scheduleBatchUpdate();
  }

  /// Remove a pending update
  void removeUpdate(K key) {
    _pendingUpdates.remove(key);
  }

  /// Schedule a batch update if not already scheduled
  void _scheduleBatchUpdate() {
    _batchUpdateTimer ??= Timer(_batchInterval, _processBatchUpdates);
  }

  /// Process all pending updates
  void _processBatchUpdates() {
    if (_pendingUpdates.isEmpty) {
      _batchUpdateTimer = null;
      return;
    }

    // Create an immutable copy of the pending updates
    final updates = Map<K, V>.from(_pendingUpdates);
    
    // Clear pending updates
    _pendingUpdates.clear();
    
    // Call the callback with the updates
    _onBatchComplete(updates);
    
    // Reset timer
    _batchUpdateTimer = null;
  }

  /// Cancel any pending batch updates
  void dispose() {
    _batchUpdateTimer?.cancel();
    _batchUpdateTimer = null;
    _pendingUpdates.clear();
  }
}

/// A stream cache to reuse streams for the same key
class StreamCache<K, V> {
  final Map<K, StreamController<V>> _streamControllers = {};

  /// Get or create a stream for the given key
  StreamController<V> getOrCreateStream(K key) {
    return _streamControllers[key] ??= StreamController<V>.broadcast();
  }

  /// Check if a stream exists for the given key
  bool hasStream(K key) => _streamControllers.containsKey(key);

  /// Add a value to the stream for the given key
  void addToStream(K key, V value) {
    final controller = getOrCreateStream(key);
    if (!controller.isClosed) {
      controller.add(value);
    }
  }

  /// Close and remove a stream for the given key
  void closeAndRemoveStream(K key) {
    final controller = _streamControllers[key];
    if (controller != null && !controller.isClosed) {
      controller.close();
      _streamControllers.remove(key);
    }
  }

  /// Check if a stream has listeners
  bool hasListeners(K key) {
    final controller = _streamControllers[key];
    return controller != null && controller.hasListener;
  }

  /// Dispose all streams
  void dispose() {
    for (final controller in _streamControllers.values) {
      if (!controller.isClosed) {
        controller.close();
      }
    }
    _streamControllers.clear();
  }
}

/// Extension methods for Riverpod Ref to help with caching
extension RefCacheExtension on Ref {
  /// Watch a provider with a cache to reduce rebuilds
  T watchWithCache<T>(
    ProviderListenable<T> provider,
    ProviderCache<String, T> cache,
    String cacheKey,
  ) {
    final value = watch(provider);
    cache.put(cacheKey, value);
    return value;
  }

  /// Read a provider with a cache to reduce rebuilds
  T readWithCache<T>(
    Provider<T> provider,
    ProviderCache<String, T> cache,
    String cacheKey,
  ) {
    // Check cache first
    final cachedValue = cache.get(cacheKey);
    if (cachedValue != null) {
      return cachedValue;
    }
    
    // Read from provider and cache
    final value = read(provider);
    cache.put(cacheKey, value);
    return value;
  }
} 