// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/feed/data/models/trending_videos_overlay.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trending_videos_overlay_provider.r.g.dart';

@riverpod
class TrendingVideosOverlayNotifier extends _$TrendingVideosOverlayNotifier {
  @override
  TrendingVideosOverlay build() {
    return Random().nextInt(2) == 0
        ? TrendingVideosOverlay.vertical
        : TrendingVideosOverlay.horizontal;
  }

  set overlay(TrendingVideosOverlay overlay) {
    state = overlay;
  }
}
