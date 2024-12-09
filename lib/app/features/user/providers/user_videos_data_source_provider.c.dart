// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/search_extension.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_videos_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? userVideosDataSource(Ref ref, String pubkey) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    return null;
  }

  return [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) =>
          entity.masterPubkey == pubkey && (entity is PostEntity || entity is RepostEntity),
      requestFilters: [
        RequestFilter(
          kinds: const [PostEntity.kind, RepostEntity.kind],
          authors: [pubkey],
          search: SearchExtensions.withCounters(
            [
              ReferencesSearchExtension(contain: false),
              ExpirationSearchExtension(expiration: false),
              VideosSearchExtension(contain: true),
            ],
            currentPubkey: currentPubkey,
          ).toString(),
          limit: 10,
        ),
      ],
    ),
  ];
}
