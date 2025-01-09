// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/quoted_entity_frame/quoted_entity_frame.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';

class QuotedEntity extends HookConsumerWidget {
  const QuotedEntity({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionConnectEntity =
        ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;

    if (ionConnectEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    final quoteChild = useMemoized(
      () {
        switch (ionConnectEntity) {
          case PostEntity():
            return QuotedEntityFrame.post(
              child: Post(
                eventReference: eventReference,
                header: UserInfo(pubkey: eventReference.pubkey),
                footer: const SizedBox.shrink(),
              ),
            );
          case ArticleEntity():
            return QuotedEntityFrame.article(
              child: Article.quoted(
                eventReference: eventReference,
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
      [ionConnectEntity],
    );

    return Padding(
      padding: EdgeInsets.only(left: 40.0.s, top: 16.0.s),
      child: quoteChild,
    );
  }
}
