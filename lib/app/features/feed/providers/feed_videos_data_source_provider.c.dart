// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/action_source.c.dart';
import 'package:ion/app/features/ion_connect/data/models/entities_paged_data_models.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/search_extension.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_videos_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedVideosDataSource(
  Ref ref, {
  required EventReference eventReference,
}) {
  final filters = ref.watch(feedCurrentFilterProvider.select((state) => state.filter));
  final filterRelays = ref.watch(feedFilterRelaysProvider).valueOrNull;
  final until =
      ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull?.createdAt;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (filterRelays == null || until == null || currentPubkey == null) return null;

  return filterRelays.entries.map((entry) {
    final authors = filters == FeedFilter.following ? entry.value : null;
    return EntitiesDataSource(
      actionSource: ActionSourceRelayUrl(entry.key),
      entityFilter: (entity) {
        if (authors != null && !authors.contains(entity.masterPubkey)) {
          return false;
        }

        return (entity is ModifiablePostEntity &&
                entity.data.parentEvent == null &&
                entity.data.quotedEvent == null) ||
            entity is GenericRepostEntity;
      },
      requestFilters: [
        RequestFilter(
          kinds: const [ModifiablePostEntity.kind, GenericRepostEntity.kind],
          search: SearchExtensions.withCounters(
            [
              ReferencesSearchExtension(contain: false),
              ExpirationSearchExtension(expiration: false),
              VideosSearchExtension(contain: true),
            ],
            currentPubkey: currentPubkey,
          ).toString(),
          authors: authors,
          limit: 5,
          until: until,
        ),
      ],
    );
  }).toList();
}
