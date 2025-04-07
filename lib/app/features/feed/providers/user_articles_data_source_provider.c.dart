// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_articles_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? userArticlesDataSource(Ref ref, String pubkey) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    return null;
  }

  final search = SearchExtensions.withCounters(
    [],
    currentPubkey: currentPubkey,
    forKind: ArticleEntity.kind,
  ).toString();

  return [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) =>
          entity.masterPubkey == pubkey &&
          (entity is ArticleEntity || entity is GenericRepostEntity),
      requestFilters: [
        RequestFilter(
          kinds: const [ArticleEntity.kind],
          authors: [pubkey],
          search: search,
          limit: 10,
        ),
        RequestFilter(
          kinds: const [GenericRepostEntity.kind],
          authors: [pubkey],
          tags: {
            '#k': [ArticleEntity.kind.toString()],
          },
          search: search,
          limit: 10,
        ),
      ],
    ),
  ];
}
