// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/entity_comments_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/entity_likes_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/entity_reposts_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/entity_share_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';

class FeedItemFooter extends HookConsumerWidget {
  FeedItemFooter({
    required this.eventReference,
    required this.kind,
    double? bottomPadding,
    double? topPadding,
    super.key,
  })  : bottomPadding = bottomPadding ?? 16.0.s,
        topPadding = topPadding ?? 10.0.s;

  final EventReference eventReference;
  final int kind;
  final double bottomPadding;
  final double topPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: EntityCommentsButton(eventReference: eventReference)),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [EntityRepostsButton(eventReference: eventReference)],
            ),
          ),
          const Spacer(),
          Flexible(child: EntityLikesButton(eventReference: eventReference)),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [EntityShareButton(eventReference: eventReference)],
            ),
          ),
        ],
      ),
    );
  }
}
