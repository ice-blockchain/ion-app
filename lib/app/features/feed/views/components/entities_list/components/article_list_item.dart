// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/router/app_routes.dart';

class ArticleListItem extends ConsumerWidget {
  const ArticleListItem({required this.article, super.key});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventReference = EventReference(eventId: article.id, pubkey: article.pubkey);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0.s),
      child: GestureDetector(
        onTap: () =>
            ArticleDetailsRoute(eventReference: eventReference.toString()).push<void>(context),
        child: Article(
          eventReference: eventReference,
        ),
      ),
    );
  }
}
