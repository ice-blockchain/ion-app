// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_stories_data_source_provider.g.dart';

@riverpod
List<EntitiesDataSource>? feedStoriesDataSource(Ref ref) {
  final filterRelays = ref.watch(feedFilterRelaysProvider(FeedFilter.following)).valueOrNull;

  if (filterRelays != null) {
    final dataSources = [
      for (final entry in filterRelays.entries)
        EntitiesDataSource(
          actionSource: ActionSourceRelayUrl(entry.key),
          entityFilter: (entity) => entity is PostEntity,
          requestFilters: [
            const RequestFilter(
              kinds: [PostEntity.kind],
              // TODO: uncomment when our relays are used
              // authors: [entry.value],
              limit: 50,
            ),
          ],
        ),
    ];

    return dataSources;
  }
  return null;
}
