// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_posts_data_source_provider.g.dart';

@riverpod
List<EntitiesDataSource> userPostsDataSource(Ref ref, String pubkey) {
  return [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) => entity is PostEntity || entity is RepostEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [PostEntity.kind, RepostEntity.kind],
          authors: [pubkey],
          limit: 10,
        ),
      ],
    ),
  ];
}
