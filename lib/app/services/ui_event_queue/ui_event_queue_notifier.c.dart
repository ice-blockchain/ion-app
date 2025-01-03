// SPDX-License-Identifier: ice License 1.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_event_queue_notifier.c.g.dart';

abstract class UiEvent {
  const UiEvent();

  void performAction(BuildContext context);
}

@Riverpod(keepAlive: true)
class UiEventQueueNotifier extends _$UiEventQueueNotifier {
  @override
  Queue<UiEvent> build() {
    return Queue();
  }

  void emit(UiEvent event) {
    state = Queue.of(state)..add(event);
  }

  UiEvent? consume() {
    if (state.isEmpty) return null;
    final nextEvent = state.first;
    state = Queue.of(state)..removeFirst();
    return nextEvent;
  }
}
