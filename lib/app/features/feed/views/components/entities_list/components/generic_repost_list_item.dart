// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article_data.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_header/repost_author_header.dart';
import 'package:ion/app/router/app_routes.dart';

class GenericRepostListItem extends StatelessWidget {
  const GenericRepostListItem({required this.repost, super.key});

  final GenericRepostEntity repost;

  @override
  Widget build(BuildContext context) {
    if (repost.data.kind != ArticleEntity.kind) {
      return Text('Repost of kind ${repost.data.kind} is not supported');
    }

    return GestureDetector(
      onTap: () => ArticleDetailsRoute(articleId: repost.data.eventId, pubkey: repost.data.pubkey)
          .push<void>(context),
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            RepostAuthorHeader(pubkey: repost.pubkey),
            SizedBox(height: 6.0.s),
            Article(
              articleId: repost.data.eventId,
              pubkey: repost.data.pubkey,
            ),
          ],
        ),
      ),
    );
  }
}