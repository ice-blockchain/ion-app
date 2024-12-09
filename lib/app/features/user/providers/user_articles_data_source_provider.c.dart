// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_articles_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource> userArticlesDataSource(Ref ref, String pubkey) {
  return [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) => entity is ArticleEntity || entity is GenericRepostEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [ArticleEntity.kind],
          authors: [pubkey],
          limit: 10,
        ),
        RequestFilter(
          kinds: const [GenericRepostEntity.kind],
          authors: [pubkey],
          k: [ArticleEntity.kind.toString()],
          limit: 10,
        ),
      ],
    ),
  ];
}
