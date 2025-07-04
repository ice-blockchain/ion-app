// SPDX-License-Identifier: ice License 1.0

class RetryCounter {
  RetryCounter({
    required this.limit,
  }) : _current = 0;

  final int limit;
  int _current;

  bool get isReached => _current >= limit;

  int get triesLeft => limit - _current;

  void increment() {
    _current++;
  }
}
