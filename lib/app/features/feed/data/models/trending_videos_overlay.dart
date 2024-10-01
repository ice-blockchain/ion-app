// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

enum TrendingVideosOverlay {
  horizontal,
  vertical;

  Size get itemSize {
    return switch (this) {
      TrendingVideosOverlay.horizontal => Size(240.0.s, 160.0.s),
      TrendingVideosOverlay.vertical => Size(140.0.s, 220.0.s),
    };
  }
}
