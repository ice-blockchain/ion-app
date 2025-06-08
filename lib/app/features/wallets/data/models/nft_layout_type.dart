// SPDX-License-Identifier: ice License 1.0

import 'package:ion/generated/assets.gen.dart';

enum NftLayoutType {
  list,
  grid;

  String get iconAsset {
    return switch (this) {
      NftLayoutType.grid => Assets.svg.iconBlockGrid,
      NftLayoutType.list => Assets.svg.iconBlockList,
    };
  }
}
