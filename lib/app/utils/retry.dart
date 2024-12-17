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
  var currentDelay = initialDelay;
  final random = Random();

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

      final jitter = minJitter + (maxJitter - minJitter) * random.nextDouble();
      final jitteredDelay = Duration(
        milliseconds: (currentDelay.inMilliseconds * jitter).round(),
      );

      currentDelay = Duration(
        milliseconds: min(jitteredDelay.inMilliseconds, maxDelay.inMilliseconds),
      );

      Logger.log('Retry #$attempt after ${currentDelay.inMilliseconds}ms...');
      await Future<void>.delayed(currentDelay);

      currentDelay = Duration(
        milliseconds: (currentDelay.inMilliseconds * multiplier).toInt(),
      );
    }
    onRetry?.call();
  }

  throw Exception('Unreachable');
}
