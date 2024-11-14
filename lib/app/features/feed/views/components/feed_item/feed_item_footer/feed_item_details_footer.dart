// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_details_action_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';

class FeedItemDetailsFooter extends StatelessWidget {
  const FeedItemDetailsFooter({
    required this.entityId,
    super.key,
  });

  final String entityId;

  @override
  Widget build(BuildContext context) {
    const postDate = '9:34  20.06.2023';
    final colors = context.theme.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10.0.s),
        Text(
          postDate,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: colors.quaternaryText,
          ),
        ),
        SizedBox(height: 12.0.s),
        FeedItemFooter(
          entityId: entityId,
          bottomPadding: 12.0.s,
          actionBuilder: (context, child, onPressed) => FeedItemDetailsActionButton(
            onPressed: onPressed,
            child: child,
          ),
        ),
      ],
    );
  }
}
