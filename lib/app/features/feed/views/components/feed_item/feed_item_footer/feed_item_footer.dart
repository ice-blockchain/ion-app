// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/entity_likes_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/entity_replies_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/entity_reposts_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/entity_share_button.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';

class FeedItemFooter extends HookConsumerWidget {
  FeedItemFooter({
    required this.eventReference,
    double? bottomPadding,
    double? topPadding,
    this.color,
    super.key,
  })  : bottomPadding = bottomPadding ?? 16.0.s,
        topPadding = topPadding ?? 10.0.s;

  final EventReference eventReference;
  final double bottomPadding;
  final double topPadding;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: EntityRepliesButton(
              eventReference: eventReference,
              color: color,
            ),
          ),
          Flexible(
            child: EntityRepostsButton(
              eventReference: eventReference,
              color: color,
            ),
          ),
          Flexible(
            child: EntityLikesButton(
              eventReference: eventReference,
              color: color,
            ),
          ),
          EntityShareButton(
            eventReference: eventReference,
            color: color,
          ),
        ],
      ),
    );
  }
}
