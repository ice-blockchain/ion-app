// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum FeedSearchSource {
  @JsonValue('anyone')
  anyone,

  @JsonValue('following')
  following;

  String getIcon(BuildContext context, {double? size, Color? color}) {
    return switch (this) {
      FeedSearchSource.anyone => Assets.svgIconSearchAnyone,
      FeedSearchSource.following => Assets.svgIconSearchFollow,
    };
  }

  String getLabel(BuildContext context) {
    return switch (this) {
      FeedSearchSource.anyone => context.i18n.feed_search_filter_anyone,
      FeedSearchSource.following => context.i18n.feed_search_filter_following,
    };
  }
}
