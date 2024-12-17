// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:ion/app/services/logger/logger.dart';

Future<T> withRetry<T>(
  Future<T> Function() task, {
  int maxRetries = 10,
  Duration initialDelay = const Duration(milliseconds: 100),
  Duration maxDelay = const Duration(seconds: 10),
  double multiplier = 3,
  double minJitter = 0.5,
  double maxJitter = 1.5,
  VoidCallback? onRetry,
}) async {
  return withRetryStream<T>(
    () async* {
      await task();
    },
    maxRetries: maxRetries,
    initialDelay: initialDelay,
    maxDelay: maxDelay,
    multiplier: multiplier,
    minJitter: minJitter,
    maxJitter: maxJitter,
    onRetry: onRetry,
  ).first;
}

Stream<T> withRetryStream<T>(
  Stream<T> Function() task, {
  int maxRetries = 10,
  Duration initialDelay = const Duration(milliseconds: 100),
  Duration maxDelay = const Duration(seconds: 10),
  double multiplier = 3,
  double minJitter = 0.5,
  double maxJitter = 1.5,
  VoidCallback? onRetry,
}) async* {
  var attempt = 0;
  var delay = initialDelay;

  while (attempt < maxRetries) {
    try {
      await for (final event in task()) {
        yield event;
      }
      return;
    } catch (e) {
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

      Logger.log('Retry #$attempt after ${delay.inMilliseconds}ms... Last error: $e');
      await Future<void>.delayed(delay);
    }
    onRetry?.call();
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
