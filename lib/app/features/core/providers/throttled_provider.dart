// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
extension ThrottledProvider<T, Q> on ProviderFamily<T?, Q> {
  StreamProviderFamily<T?, Q> throttled() {
    return StreamProvider.family<T?, Q>((ref, params) async* {
      T? lastValue;
      final controller = StreamController<T?>();
      Timer? throttleTimer;
      var hasPending = false;

      void emitThrottled() {
        if (throttleTimer == null || !throttleTimer!.isActive) {
          controller.add(lastValue);
          throttleTimer = Timer(const Duration(milliseconds: 200), () {
            if (hasPending) {
              controller.add(lastValue);
              hasPending = false;
              throttleTimer = Timer(const Duration(milliseconds: 200), emitThrottled);
            } else {
              throttleTimer = null;
            }
          });
        } else {
          hasPending = true;
        }
      }

      final sub = ref.listen<T?>(this(params), (prev, next) {
        lastValue = next;
        emitThrottled();
      });

      lastValue = ref.read(this(params));
      emitThrottled();

      yield* controller.stream;

      ref.onDispose(() {
        throttleTimer?.cancel();
        controller.close();
        sub.close();
      });
    });
  }
}

extension X<T> on ProviderListenable<T?> {
  ProviderListenable<T?> throttled() {
    return StreamProvider<T?>((ref) async* {
      T? lastValue;
      final controller = StreamController<T?>();
      Timer? throttleTimer;
      var hasPending = false;

      void emitThrottled() {
        if (throttleTimer == null || !throttleTimer!.isActive) {
          controller.add(lastValue);
          throttleTimer = Timer(const Duration(milliseconds: 200), () {
            if (hasPending) {
              controller.add(lastValue);
              hasPending = false;
              throttleTimer = Timer(const Duration(milliseconds: 200), emitThrottled);
            } else {
              throttleTimer = null;
            }
          });
        } else {
          hasPending = true;
        }
      }

      final sub = ref.listen<T?>(this, (prev, next) {
        lastValue = next;
        emitThrottled();
      });

      lastValue = ref.read(this);
      emitThrottled();

      yield* controller.stream;

      ref.onDispose(() {
        throttleTimer?.cancel();
        controller.close();
        sub.close();
      });
    }) as ProviderListenable<T?>;
  }
}
