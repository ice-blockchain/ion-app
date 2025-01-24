// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_stories_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedStoriesDataSource(Ref ref) {
  final filterRelays = ref.watch(feedFilterRelaysProvider(FeedFilter.forYou)).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

  if (filterRelays == null || currentPubkey == null) {
    return null;
  }

  final dataSources = [
    for (final entry in filterRelays.entries)
      EntitiesDataSource(
        actionSource: ActionSourceRelayUrl(entry.key),
        entityFilter: (entity) => entity is ModifiablePostEntity,
        requestFilters: [
          RequestFilter(
            kinds: const [ModifiablePostEntity.kind, GenericRepostEntity.kind],
            authors: [currentPubkey, ...entry.value],
            search: SearchExtensions(
              [
                ReactionsSearchExtension(currentPubkey: currentPubkey),
                ReferencesSearchExtension(contain: false),
                ExpirationSearchExtension(expiration: true),
                VideosSearchExtension(contain: true),
                GenericIncludeSearchExtension(
                  forKind: ModifiablePostEntity.kind,
                  includeKind: UserMetadataEntity.kind,
                ),
                GenericIncludeSearchExtension(
                  forKind: ModifiablePostEntity.kind,
                  includeKind: BlockListEntity.kind,
                ),
              ],
            ).toString(),
            limit: 10,
          ),
          RequestFilter(
            kinds: const [ModifiablePostEntity.kind, GenericRepostEntity.kind],
            authors: [currentPubkey, ...entry.value],
            search: SearchExtensions(
              [
                ReactionsSearchExtension(currentPubkey: currentPubkey),
                ReferencesSearchExtension(contain: false),
                ExpirationSearchExtension(expiration: true),
                ImagesSearchExtension(contain: true),
                GenericIncludeSearchExtension(
                  forKind: ModifiablePostEntity.kind,
                  includeKind: UserMetadataEntity.kind,
                ),
                GenericIncludeSearchExtension(
                  forKind: ModifiablePostEntity.kind,
                  includeKind: BlockListEntity.kind,
                ),
              ],
            ).toString(),
            limit: 10,
          ),
        ],
      ),
  ];

  return dataSources;
}
