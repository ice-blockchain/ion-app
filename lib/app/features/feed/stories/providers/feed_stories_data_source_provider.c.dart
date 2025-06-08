// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/action_source.c.dart';
import 'package:ion/app/features/ion_connect/data/models/entities_paged_data_models.c.dart';
import 'package:ion/app/features/ion_connect/data/models/search_extension.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user/data/models/block_list.c.dart';
import 'package:ion/app/features/user/data/models/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_stories_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedStoriesDataSource(Ref ref) {
  final filterRelays = ref.watch(feedForYouFilterRelaysProvider).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (filterRelays == null || currentPubkey == null) {
    return null;
  }

  final searchVideos = SearchExtensions(
    [
      ReactionsSearchExtension(currentPubkey: currentPubkey),
      ReferencesSearchExtension(contain: false),
      ExpirationSearchExtension(expiration: true),
      VideosSearchExtension(contain: true),
      GenericIncludeSearchExtension(
        forKind: ModifiablePostEntity.kind,
        includeKind: UserMetadataEntity.kind,
      ),
      ProfileBadgesSearchExtension(forKind: ModifiablePostEntity.kind),
      GenericIncludeSearchExtension(
        forKind: ModifiablePostEntity.kind,
        includeKind: BlockListEntity.kind,
      ),
    ],
  ).toString();

  final searchImages = SearchExtensions(
    [
      ReactionsSearchExtension(currentPubkey: currentPubkey),
      ReferencesSearchExtension(contain: false),
      ExpirationSearchExtension(expiration: true),
      ImagesSearchExtension(contain: true),
      GenericIncludeSearchExtension(
        forKind: ModifiablePostEntity.kind,
        includeKind: UserMetadataEntity.kind,
      ),
      ProfileBadgesSearchExtension(forKind: ModifiablePostEntity.kind),
      GenericIncludeSearchExtension(
        forKind: ModifiablePostEntity.kind,
        includeKind: BlockListEntity.kind,
      ),
    ],
  ).toString();

  final dataSources = [
    for (final entry in filterRelays.entries)
      EntitiesDataSource(
        actionSource: ActionSourceRelayUrl(entry.key),
        entityFilter: (entity) => entity is ModifiablePostEntity,
        requestFilters: [
          RequestFilter(
            kinds: const [ModifiablePostEntity.kind],
            authors: [currentPubkey, ...entry.value],
            search: searchVideos,
            limit: 10,
          ),
          RequestFilter(
            kinds: const [ModifiablePostEntity.kind],
            authors: [currentPubkey, ...entry.value],
            search: searchImages,
            limit: 10,
          ),
        ],
      ),
  ];

  return dataSources;
}
