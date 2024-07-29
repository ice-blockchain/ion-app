import 'dart:async';

/// An in-memory store backed by BehaviorSubject that can be used to
/// store the data for all the fake repositories in the app.
/// It is a simple implementation of the BehaviorSubject class from RxDart.
class InMemoryStore<T> {
  InMemoryStore(T initial) : _value = initial;

  /// The private field that holds the data
  T _value;

  /// The controller for the output stream
  final _controller = StreamController<T>.broadcast();

  /// The output stream that can be used to listen to the data
  Stream<T> get stream => _controller.stream;

  /// A synchronous getter for the current value
  T get value => _value;

  /// A setter for updating the value
  set value(T newValue) {
    _value = newValue;
    _controller.add(_value);
  }

  /// Add an error to the stream
  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  /// Don't forget to call this when done
  void close() => _controller.close();
}
