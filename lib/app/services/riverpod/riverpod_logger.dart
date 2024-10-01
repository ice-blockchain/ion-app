// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/services/logger/logger.dart';

class RiverpodLogger extends ProviderObserver {
  static const String tag = 'Riverpod';

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _log('Provider $provider was initialized with $value');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _log('Provider $provider was disposed');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _log('Provider $provider updated from $previousValue to $newValue');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _log(
      'Provider $provider threw error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _log(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    Logger.log(message, name: tag, error: error, stackTrace: stackTrace);
  }
}
