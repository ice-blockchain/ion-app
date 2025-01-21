// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum RepostOptionAction {
  repost,
  undoRepost,
  quotePost;

  String getLabel(BuildContext context) => switch (this) {
        RepostOptionAction.repost => context.i18n.feed_repost,
        RepostOptionAction.undoRepost => context.i18n.feed_undo_repost,
        RepostOptionAction.quotePost => context.i18n.feed_quote,
      };

  Color getIconColor(BuildContext context) => switch (this) {
        RepostOptionAction.repost => context.theme.appColors.primaryAccent,
        RepostOptionAction.undoRepost => context.theme.appColors.primaryAccent,
        RepostOptionAction.quotePost => context.theme.appColors.primaryAccent,
      };

  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      RepostOptionAction.repost => Assets.svg.iconFeedRepost,
      RepostOptionAction.undoRepost => Assets.svg.iconFeedRepost,
      RepostOptionAction.quotePost => Assets.svg.iconFeedQuote,
    };

    return icon.icon(color: getIconColor(context));
  }
}
