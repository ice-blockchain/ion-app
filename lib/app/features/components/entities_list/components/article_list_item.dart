// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ArticleListItem extends ConsumerWidget {
  const ArticleListItem({required this.article, super.key});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventReference = EventReference.fromNostrEntity(article);

    return Padding(
      padding: EdgeInsets.only(top: 12.0.s, bottom: 12.0.s, right: 16.0.s),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            ArticleDetailsRoute(eventReference: eventReference.toString()).push<void>(context),
        child: Article(
          eventReference: eventReference,
        ),
      ),
    );
  }
}
