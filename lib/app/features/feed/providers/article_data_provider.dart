// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/article_data.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'article_data_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
Future<ArticleEntity?> articleData(
  Ref ref, {
  required String articleId,
  required String pubkey,
}) async {
  final article = ref.watch(
    nostrCacheProvider
        .select(cacheSelector<ArticleEntity>(ArticleEntity.cacheKeyBuilder(id: articleId))),
  );
  if (article != null) {
    return article;
  }

  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [ArticleEntity.kind], ids: [articleId], limit: 1));
  return ref.read(nostrNotifierProvider.notifier).requestEntity<ArticleEntity>(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
}
