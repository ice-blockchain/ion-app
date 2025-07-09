// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class _ThrottlingController<T> {
  _ThrottlingController({
    Duration? throttleDuration,
    bool useRecursivePending = false,
  })  : _throttleDuration = throttleDuration ?? const Duration(milliseconds: 300),
        _useRecursivePending = useRecursivePending;

  final StreamController<T> _controller = StreamController<T>();
  final Duration _throttleDuration;
  final bool _useRecursivePending;

  Timer? _throttleTimer;
  T? _lastValue;
  bool _hasPending = false;
  bool _isInitial = true;

  Stream<T> get stream => _controller.stream;

  void emitThrottled(T? value) {
    if (value != null) {
      _lastValue = value;

      if (_useRecursivePending) {
        _emitWithPendingLogic(value);
      } else {
        _emitWithSimpleLogic(value);
      }
    }
  }

  void _emitWithPendingLogic(T value) {
    if (_throttleTimer == null || !_throttleTimer!.isActive) {
      _controller.add(value);
      _throttleTimer = Timer(_throttleDuration, () {
        if (_hasPending && _lastValue != null) {
          _controller.add(_lastValue as T);
          _hasPending = false;
          _throttleTimer = Timer(_throttleDuration, _emitPendingRecursive);
        } else {
          _throttleTimer = null;
        }
      });
    } else {
      _hasPending = true;
    }
  }

  void _emitWithSimpleLogic(T value) {
    if (_isInitial) {
      _controller.add(value);
      _isInitial = false;
    } else {
      _scheduleEmit();
    }
  }

  void _emitPendingRecursive() {
    if (_hasPending && _lastValue != null) {
      _controller.add(_lastValue as T);
      _hasPending = false;
      _throttleTimer = Timer(_throttleDuration, _emitPendingRecursive);
    } else {
      _throttleTimer = null;
    }
  }

  void _scheduleEmit() {
    _throttleTimer?.cancel();
    _throttleTimer = Timer(_throttleDuration, () {
      if (_lastValue != null) {
        _controller.add(_lastValue as T);
      }
    });
  }

  void dispose() {
    _throttleTimer?.cancel();
    _controller.close();
  }
}

extension ThrottledProvider<T, Q> on ProviderFamily<T?, Q> {
  StreamProviderFamily<T?, Q> throttled() {
    return StreamProvider.family<T?, Q>((ref, params) async* {
      final throttlingController = _ThrottlingController<T?>(
        useRecursivePending: true,
      );

      final sub = ref.listen<T?>(this(params), (prev, next) {
        throttlingController.emitThrottled(next);
      });

      final initialValue = ref.read(this(params));
      throttlingController.emitThrottled(initialValue);

      yield* throttlingController.stream;

      ref.onDispose(() {
        throttlingController.dispose();
        sub.close();
      });
    });
  }
}

extension ThrottledStreamProvider<T> on StreamProvider<T> {
  StreamProvider<T> throttled() {
    return StreamProvider<T>((ref) async* {
      final throttlingController = _ThrottlingController<T>(
        useRecursivePending: false,
      );

      final sub = ref.listen(this, (prev, next) {
        final value = next.valueOrNull;
        throttlingController.emitThrottled(value);
      });

      final initialValue = ref.read(this).valueOrNull;
      throttlingController.emitThrottled(initialValue);

      yield* throttlingController.stream;

      ref.onDispose(() {
        throttlingController.dispose();
        sub.close();
      });
    });
  }
}
