// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';

class VideoActions extends StatelessWidget {
  const VideoActions({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0.s,
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      color: context.theme.appColors.primaryText,
      child: FeedItemFooter(
        bottomPadding: 0,
        topPadding: 0,
        eventReference: eventReference,
        color: context.theme.appColors.secondaryBackground,
      ),
    );
  }
}
