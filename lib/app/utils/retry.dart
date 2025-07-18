// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:math';

import 'package:ion/app/services/logger/logger.dart';

Future<T> withRetry<T>(
  Future<T> Function({Object? error}) task, {
  int maxRetries = 10,
  Duration initialDelay = const Duration(milliseconds: 100),
  Duration maxDelay = const Duration(seconds: 10),
  double multiplier = 3,
  double minJitter = 0.5,
  double maxJitter = 1.5,
  FutureOr<void> Function(Object? error)? onRetry,
  bool Function(Object)? retryWhen,
}) async {
  return withRetryStream<T>(
    ({error}) => Stream.fromFuture(task(error: error)),
    maxRetries: maxRetries,
    initialDelay: initialDelay,
    maxDelay: maxDelay,
    multiplier: multiplier,
    minJitter: minJitter,
    maxJitter: maxJitter,
    onRetry: onRetry,
    retryWhen: retryWhen,
  ).first;
}

Stream<T> withRetryStream<T>(
  Stream<T> Function({Object? error}) task, {
  int maxRetries = 10,
  Duration initialDelay = const Duration(milliseconds: 100),
  Duration maxDelay = const Duration(seconds: 10),
  double multiplier = 3,
  double minJitter = 0.5,
  double maxJitter = 1.5,
  FutureOr<void> Function(Object? error)? onRetry,
  bool Function(Object)? retryWhen,
}) async* {
  var attempt = 0;
  var delay = initialDelay;
  Object? lastError;

  while (attempt < maxRetries) {
    try {
      await for (final event in task(error: lastError)) {
        yield event;
        attempt = 0;
        delay = initialDelay;
      }
      return;
    } catch (e) {
      lastError = e;

      final shouldRetry = retryWhen?.call(e) ?? true;
      if (!shouldRetry) {
        rethrow;
      }

      Logger.log(e.toString());
      attempt++;
      if (attempt >= maxRetries) {
        rethrow;
      }

      delay = _getNextRetryDelay(
        currentDelay: delay,
        maxDelay: maxDelay,
        multiplier: multiplier,
        minJitter: minJitter,
        maxJitter: maxJitter,
      );

      Logger.log('Retry #$attempt after ${delay.inMilliseconds}ms...');
      await Future<void>.delayed(delay);
    }

    await onRetry?.call(lastError);
  }

  throw Exception('Unreachable');
}

Duration _getNextRetryDelay({
  required Duration currentDelay,
  required Duration maxDelay,
  required double multiplier,
  required double minJitter,
  required double maxJitter,
}) {
  final random = Random();
  final jitter = minJitter + (maxJitter - minJitter) * random.nextDouble() * multiplier;

  final jitteredDelay = Duration(
    milliseconds: (currentDelay.inMilliseconds * jitter).round(),
  );

  return Duration(
    milliseconds: min(jitteredDelay.inMilliseconds, maxDelay.inMilliseconds),
  );
}
