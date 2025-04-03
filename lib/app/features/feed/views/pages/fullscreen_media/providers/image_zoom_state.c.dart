// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_zoom_state.c.g.dart';

@riverpod
class ImageZoomState extends _$ImageZoomState {
  @override
  bool build() => false;

  set zoomed(bool value) => state = value;
}

/// Tracks whether an interaction (pan/scale) is currently active
/// within the InteractiveViewer used for image zooming.
@riverpod
class ImageInteractionState extends _$ImageInteractionState {
  @override
  bool build() => false; // Initial state: no interaction active

  /// Sets the interaction state.
  void setInteracting(bool value) => state = value;
}