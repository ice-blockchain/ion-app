import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/build_context.dart';

enum FeedFilter {
  forYou,
  following;

  String getLabel(BuildContext context) => switch (this) {
        FeedFilter.forYou => context.i18n.feed_for_you,
        FeedFilter.following => context.i18n.feed_following,
      };
}
