// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

enum FeedSearchFilterPeople {
  anyone,
  following;

  String getIcon(BuildContext context, {double? size, Color? color}) {
    return switch (this) {
      FeedSearchFilterPeople.anyone => Assets.svg.iconSearchAnyone,
      FeedSearchFilterPeople.following => Assets.svg.iconSearchFollow,
    };
  }

  String getLabel(BuildContext context) {
    return switch (this) {
      FeedSearchFilterPeople.anyone => context.i18n.feed_search_filter_anyone,
      FeedSearchFilterPeople.following => context.i18n.feed_search_filter_following,
    };
  }
}
