// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/article_data.dart';
import 'package:ion/app/features/feed/providers/fake_articles_generator.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mock_article_entities_paged_data_provider.c.g.dart';

@riverpod
class MockArticleEntitiesPagedData extends _$MockArticleEntitiesPagedData {
  @override
  List<ArticleEntity>? build(List<EntitiesDataSource>? dataSources) {
    if (dataSources != null) {
      Future.microtask(fetchEntities);
      return [];
    }
    return null;
  }

  Future<void> fetchEntities() async {
    if (dataSources == null) {
      return;
    }

    final mockedArticles = List.generate(
      dataSources!.first.requestFilters.first.limit ?? 10,
      (_) => generateFakeArticle(),
    );

    state = [...state ?? [], ...mockedArticles];
  }
}
