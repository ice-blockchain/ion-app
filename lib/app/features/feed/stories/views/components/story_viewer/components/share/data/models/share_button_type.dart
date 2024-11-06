// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum ShareButtonType {
  copyLink,
  whatsapp,
  telegram,
  x,
  more;

  String label(BuildContext context) {
    final locale = context.i18n;

    return switch (this) {
      ShareButtonType.copyLink => locale.feed_copy_link,
      ShareButtonType.whatsapp => locale.feed_whatsapp,
      ShareButtonType.telegram => locale.feed_telegram,
      ShareButtonType.x => locale.feed_x,
      ShareButtonType.more => locale.feed_more,
    };
  }

  Widget icon(BuildContext context) => switch (this) {
        ShareButtonType.copyLink => Assets.svg.iconBlockCopy1.icon(
            color: context.theme.appColors.primaryText,
          ),
        ShareButtonType.whatsapp => Assets.svg.iconFeedWhatsapp.icon(),
        ShareButtonType.telegram => Assets.svg.iconFeedTelegram.icon(),
        ShareButtonType.x => Assets.svg.iconLoginXlogo.icon(),
        ShareButtonType.more => Assets.svg.iconFeedMore.icon(),
      };
}
