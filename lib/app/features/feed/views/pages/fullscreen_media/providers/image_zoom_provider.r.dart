// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_zoom_provider.r.g.dart';

@riverpod
class ImageZoom extends _$ImageZoom {
  @override
  bool build() => false;

  set zoomed(bool value) => state = value;
}
