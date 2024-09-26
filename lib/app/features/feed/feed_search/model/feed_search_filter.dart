import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

enum FeedSearchFilter {
  anyone,
  following;

  String getIcon(BuildContext context, {double? size, Color? color}) {
    return switch (this) {
      FeedSearchFilter.anyone => Assets.svg.iconSearchAnyone,
      FeedSearchFilter.following => Assets.svg.iconSearchFollow,
    };
  }

  String getLabel(BuildContext context) {
    return switch (this) {
      FeedSearchFilter.anyone => context.i18n.feed_search_filter_anyone,
      FeedSearchFilter.following => context.i18n.feed_search_filter_following,
    };
  }
}
