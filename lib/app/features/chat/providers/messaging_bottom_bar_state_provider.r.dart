// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_bottom_bar_state_provider.r.g.dart';

enum VoiceRecordingState {
  idle,
  started,
  locked,
  paused;

  bool get isIdle => this == VoiceRecordingState.idle;
  bool get isStarted => this == VoiceRecordingState.started;
  bool get isLocked => this == VoiceRecordingState.locked;
  bool get isPaused => this == VoiceRecordingState.paused;
}

@riverpod
class VoiceRecordingActiveState extends _$VoiceRecordingActiveState {
  @override
  VoiceRecordingState build() {
    return VoiceRecordingState.idle;
  }

  void start() {
    state = VoiceRecordingState.started;
  }

  void lock() {
    state = VoiceRecordingState.locked;
  }

  void pause() {
    state = VoiceRecordingState.paused;
  }
}
