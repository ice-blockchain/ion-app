// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';

class RestartableTimer implements Timer {
  RestartableTimer(this._duration, this._callback) : _timer = Timer(_duration, _callback);

  final Duration _duration;
  final VoidCallback _callback;
  Timer _timer;

  @override
  bool get isActive => _timer.isActive;

  @override
  int get tick => _timer.tick;

  void reset() {
    _timer.cancel();
    _timer = Timer(_duration, _callback);
  }

  @override
  void cancel() {
    _timer.cancel();
  }
}
