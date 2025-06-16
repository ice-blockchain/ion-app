// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum NftSortingType {
  asc,
  desc;

  String getTitle(BuildContext context) {
    return switch (this) {
      NftSortingType.asc => context.i18n.sorting_price_asc,
      NftSortingType.desc => context.i18n.sorting_price_desc,
    };
  }

  String get iconAsset {
    return switch (this) {
      NftSortingType.asc => Assets.svgIconButtonDown,
      NftSortingType.desc => Assets.svgIconButtonUp,
    };
  }
}
