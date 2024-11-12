// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_header/feed_item_header.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_menu/feed_item_menu.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';

class Post extends StatelessWidget {
  const Post({
    required this.postEntity,
    this.header,
    this.footer,
    this.footerPadding,
    super.key,
  });

  final PostEntity postEntity;
  final Widget? header;
  final Widget? footer;
  final double? footerPadding;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header ??
              FeedItemHeader(
                pubkey: postEntity.pubkey,
                trailing: FeedItemMenu(pubkey: postEntity.pubkey),
              ),
          PostBody(postEntity: postEntity),
          SizedBox(height: footerPadding ?? 10.0.s),
          footer ?? FeedItemFooter(postEntity: postEntity),
        ],
      ),
    );
  }
}
