// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum RepostOptionAction {
  repost,
  quotePost;

  String getLabel(BuildContext context) => switch (this) {
        RepostOptionAction.repost => context.i18n.feed_repost,
        RepostOptionAction.quotePost => context.i18n.feed_quote_post,
      };

  Color getIconColor(BuildContext context) => switch (this) {
        RepostOptionAction.repost => context.theme.appColors.primaryAccent,
        RepostOptionAction.quotePost => context.theme.appColors.primaryAccent,
      };

  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      RepostOptionAction.repost => Assets.svg.iconFeedRepost,
      RepostOptionAction.quotePost => Assets.svg.iconFeedQuote,
    };

    return icon.icon(color: getIconColor(context));
  }
}
