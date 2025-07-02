import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

extension ThrottledProvider<T, Q> on ProviderFamily<List<T>?, Q> {
  StreamProviderFamily<List<T>?, Q> throttled() {
    return StreamProvider.family<List<T>?, Q>((ref, params) async* {
      // final provider = _followersEntitiesProvider(params);
      List<T>? lastValue;
      final controller = StreamController<List<T>?>();
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

      final sub = ref.listen<List<T>?>(this(params), (prev, next) {
        lastValue = next;
        emitThrottled();
      });

      // Emit initial value
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
