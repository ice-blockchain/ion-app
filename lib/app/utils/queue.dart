import 'dart:async';
import 'dart:collection';

class ConcurrentTasksQueue {
  ConcurrentTasksQueue({
    required this.maxConcurrent,
  });

  final int maxConcurrent;

  int _running = 0;

  final Queue<_Task<dynamic>> _queue = Queue<_Task<dynamic>>();

  Future<T> add<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    _queue.add(_Task<T>(task, completer));
    _tryRunNext();
    return completer.future;
  }

  void cancelAll() {
    while (_queue.isNotEmpty) {
      final task = _queue.removeFirst();
      task.completer.completeError(StateError('Task was cancelled.'));
    }
  }

  void _tryRunNext() {
    if (_running >= maxConcurrent || _queue.isEmpty) return;
    final req = _queue.removeFirst();
    _running++;
    req
        .task()
        .then(req.completer.complete)
        .catchError(req.completer.completeError)
        .whenComplete(() {
      _running--;
      _tryRunNext();
    });
  }
}

class _Task<T> {
  _Task(this.task, this.completer);
  final Future<T> Function() task;
  final Completer<T> completer;
}
