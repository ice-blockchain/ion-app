// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/search_extension.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_stories_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedStoriesDataSource(Ref ref) {
  final filterRelays = ref.watch(feedFilterRelaysProvider(FeedFilter.following)).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (filterRelays == null || currentPubkey == null) {
    return null;
  }

  final dataSources = [
    for (final entry in filterRelays.entries)
      EntitiesDataSource(
        actionSource: ActionSourceRelayUrl(entry.key),
        entityFilter: (entity) => entity is PostEntity,
        requestFilters: [
          RequestFilter(
            kinds: const [PostEntity.kind, RepostEntity.kind],
            authors: entry.value,
            search: SearchExtensions(
              [
                ReactionsSearchExtension(currentPubkey: currentPubkey),
                ReferencesSearchExtension(contain: false),
                ExpirationSearchExtension(expiration: true),
                VideosSearchExtension(contain: true),
              ],
            ).toString(),
            limit: 10,
          ),
          RequestFilter(
            kinds: const [PostEntity.kind, RepostEntity.kind],
            authors: entry.value,
            search: SearchExtensions(
              [
                ReactionsSearchExtension(currentPubkey: currentPubkey),
                ReferencesSearchExtension(contain: false),
                ExpirationSearchExtension(expiration: true),
                ImagesSearchExtension(contain: true),
              ],
            ).toString(),
            limit: 10,
          ),
        ],
      ),
  ];

  return dataSources;
}
