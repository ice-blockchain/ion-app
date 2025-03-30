import 'dart:async';

/// Custom implementation of the combineLatest util.
class StreamCombiner<T, R> {
  StreamCombiner({
    required Stream<T> stream1,
    required Stream<R> stream2,
  }) {
    _subscription1 = stream1.listen((data) {
      _latestData1 = data;
      _emitCombined();
    });

    _subscription2 = stream2.listen((data) {
      _latestData2 = data;
      _emitCombined();
    });
  }

  final _controller = StreamController<(T?, R?)>.broadcast();
  late final StreamSubscription<T> _subscription1;
  late final StreamSubscription<R> _subscription2;
  T? _latestData1;
  R? _latestData2;

  Stream<(T?, R?)> get stream => _controller.stream;

  void _emitCombined() {
    if (!_controller.isClosed) {
      _controller.add((_latestData1, _latestData2));
    }
  }

  Future<void> dispose() async {
    await _subscription1.cancel();
    await _subscription2.cancel();
    await _controller.close();
  }
}
