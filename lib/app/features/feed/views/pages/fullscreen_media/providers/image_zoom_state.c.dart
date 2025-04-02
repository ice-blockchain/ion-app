// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_zoom_state.c.g.dart';

@riverpod
class ImageZoomState extends _$ImageZoomState {
  @override
  bool build() => false;

  set zoomed(bool value) => state = value;
}
