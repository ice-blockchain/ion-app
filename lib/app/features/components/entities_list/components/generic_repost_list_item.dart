// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/repost_author_header.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class GenericRepostListItem extends StatelessWidget {
  const GenericRepostListItem({required this.repost, super.key});

  final GenericRepostEntity repost;

  @override
  Widget build(BuildContext context) {
    final eventReference = repost.data.eventReference;

    if (eventReference is! ReplaceableEventReference) {
      return Text('Repost of $eventReference is not supported');
    }

    return GestureDetector(
      onTap: () => switch (eventReference.kind) {
        ArticleEntity.kind =>
          ArticleDetailsRoute(eventReference: eventReference.encode()).push<void>(context),
        ModifiablePostEntity.kind =>
          PostDetailsRoute(eventReference: eventReference.encode()).push<void>(context),
        _ => null,
      },
      behavior: HitTestBehavior.opaque,
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            RepostAuthorHeader(pubkey: repost.masterPubkey),
            SizedBox(height: 6.0.s),
            Padding(
              padding: EdgeInsets.only(right: 16.0.s),
              child: switch (eventReference.kind) {
                ArticleEntity.kind => Article(eventReference: eventReference),
                ModifiablePostEntity.kind => Post(eventReference: eventReference),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
