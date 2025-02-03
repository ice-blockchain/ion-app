// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/repost_author_header.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class RepostListItem extends ConsumerWidget {
  const RepostListItem({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repostEntity =
        ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;

    if (repostEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    return GestureDetector(
      onTap: () => switch (repostEntity) {
        RepostEntity() =>
          PostDetailsRoute(eventReference: repostEntity.data.eventReference.encode())
              .push<void>(context),
        GenericRepostEntity() when repostEntity.data.kind == ModifiablePostEntity.kind =>
          PostDetailsRoute(eventReference: repostEntity.data.eventReference.encode())
              .push<void>(context),
        GenericRepostEntity() when repostEntity.data.kind == ArticleEntity.kind =>
          ArticleDetailsRoute(eventReference: repostEntity.data.eventReference.encode())
              .push<void>(context),
        _ => null,
      },
      behavior: HitTestBehavior.opaque,
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            RepostAuthorHeader(pubkey: repostEntity.masterPubkey),
            SizedBox(height: 6.0.s),
            Padding(
              padding: EdgeInsets.only(right: 16.0.s),
              child: switch (repostEntity) {
                RepostEntity() => Post(
                    eventReference: repostEntity.data.eventReference,
                    repostReference: eventReference,
                  ),
                GenericRepostEntity() when repostEntity.data.kind == ModifiablePostEntity.kind =>
                  Post(
                    eventReference: repostEntity.data.eventReference,
                    repostReference: eventReference,
                  ),
                GenericRepostEntity() when repostEntity.data.kind == ArticleEntity.kind =>
                  Article(eventReference: repostEntity.data.eventReference),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
