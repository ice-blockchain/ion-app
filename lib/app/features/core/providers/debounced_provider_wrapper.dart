// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Generic debounced state notifier that wraps any provider
class DebouncedNotifier<T> extends StateNotifier<T?> {
  DebouncedNotifier({
    required this.ref,
    required this.originalProvider,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : super(null) {
    _init();
  }

  final Ref ref;
  final ProviderListenable<T> originalProvider;
  final Duration debounceDuration;
  Timer? _debounceTimer;

  void _init() {
    // Get initial state
    state = ref.read(originalProvider);

    // Listen for changes and debounce them
    ref.listen<T>(originalProvider, (previous, next) {
      _debouncedUpdate(next);
    });
  }

  void _debouncedUpdate(T newState) {
    _debounceTimer?.cancel();
    
    _debounceTimer = Timer(debounceDuration, () {
      if (mounted) {
        state = newState;
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Generic debounced provider factory
StateNotifierProvider<DebouncedNotifier<T>, T?> createDebouncedProvider<T, P>(
  ProviderListenable<T> originalProvider, {
  Duration debounceDuration = const Duration(milliseconds: 500),
  String? name,
}) {
  return StateNotifierProvider<DebouncedNotifier<T>, T?>(
    (ref) => DebouncedNotifier<T>(
      ref: ref,
      originalProvider: originalProvider,
      debounceDuration: debounceDuration,
    ),
    name: name,
  );
}

/// Family version for providers that take parameters
StateNotifierProvider<DebouncedNotifier<T>, T?> createDebouncedFamilyProvider<T, P>(
  ProviderFamily<T, P> originalProviderFamily,
  P parameter, {
  Duration debounceDuration = const Duration(milliseconds: 500),
  String? name,
}) {
  return StateNotifierProvider<DebouncedNotifier<T>, T?>(
    (ref) => DebouncedNotifier<T>(
      ref: ref,
      originalProvider: originalProviderFamily(parameter),
      debounceDuration: debounceDuration,
    ),
    name: name,
  );
}

/// Extension to make it easy to create debounced versions of providers
extension ProviderDebouncedExtension<T> on ProviderListenable<T> {
  StateNotifierProvider<DebouncedNotifier<T>, T?> debounced({
    Duration debounceDuration = const Duration(milliseconds: 500),
    String? name,
  }) {
    return createDebouncedProvider<T, void>(
      this,
      debounceDuration: debounceDuration,
      name: name,
    );
  }
}

/// Extension for family providers
extension ProviderFamilyDebouncedExtension<T, P> on ProviderFamily<T, P> {
  StateNotifierProvider<DebouncedNotifier<T>, T?> debouncedFor(
    P parameter, {
    Duration debounceDuration = const Duration(milliseconds: 500),
    String? name,
  }) {
    return createDebouncedFamilyProvider<T, P>(
      this,
      parameter,
      debounceDuration: debounceDuration,
      name: name,
    );
  }
}
