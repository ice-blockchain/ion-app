// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/event_reference.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_videos_data_source_provider.g.dart';

@Riverpod(dependencies: [nostrEntity])
List<EntitiesDataSource>? feedVideosDataSource(
  Ref ref, {
  required EventReference eventReference,
}) {
  final filters = ref.watch(feedCurrentFilterProvider.select((state) => state.filter));
  final filterRelays = ref.watch(feedFilterRelaysProvider(filters)).valueOrNull;
  final until =
      ref.watch(nostrEntityProvider(eventReference: eventReference)).valueOrNull?.createdAt;

  if (filterRelays == null) return null;

  final dataSources = [
    for (final entry in filterRelays.entries)
      EntitiesDataSource(
        actionSource: ActionSourceRelayUrl(entry.key),
        entityFilter: (entity) => entity is PostEntity,
        requestFilters: [
          RequestFilter(
            kinds: const [PostEntity.kind],
            authors: filters == FeedFilter.following ? entry.value : null,
            limit: 5,
            until: until,
          ),
        ],
      ),
  ];

  return dataSources;
}
