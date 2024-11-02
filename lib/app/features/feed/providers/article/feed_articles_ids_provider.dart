// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/article/article_data.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_articles_ids_provider.g.dart';

@riverpod
class FeedArticlesIds extends _$FeedArticlesIds {
  @override
  List<String> build({required FeedFiltersState filters}) {
    return [];
  }

  Future<void> fetchArticles() async {
    final requestMessage = RequestMessage()
      ..addFilter(const RequestFilter(kinds: [ArticleEntity.kind], limit: 20));
    final entitiesStream = ref.read(nostrNotifierProvider.notifier).requestEntities(requestMessage);
    await for (final entity in entitiesStream) {
      if (entity is ArticleEntity) {
        state = [...state, entity.id];
      }
    }
  }
}
