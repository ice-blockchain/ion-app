// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/paged.c.dart';
import 'package:ion/app/features/core/providers/debounced_provider_wrapper.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.c.dart';

/// Computed state for followers list that extracts entities and other useful data
class FollowersListState {
  const FollowersListState({
    this.entities,
    this.hasMore = false,
    this.isLoading = false,
  });

  final List<UserMetadataEntity>? entities;
  final bool hasMore;
  final bool isLoading;
}

/// Provider that transforms the raw entities paged data into a more UI-friendly state
final followersListStateProvider = Provider.family<FollowersListState, ({String pubkey, String? query})>((ref, params) {
  final dataSource = ref.watch(followersDataSourceProvider(params.pubkey, query: params.query));
  final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
  
  if (entitiesPagedData == null) {
    return const FollowersListState();
  }

  final entities = entitiesPagedData.data.items
      ?.whereType<UserMetadataEntity>()
      .toList();

  return FollowersListState(
    entities: entities,
    hasMore: entitiesPagedData.hasMore,
    isLoading: entitiesPagedData.data is PagedLoading,
  );
});

/// Debounced version of the followers list state provider
final debouncedFollowersListStateProvider = Provider.family<StateNotifierProvider<DebouncedNotifier<FollowersListState>, FollowersListState?>, ({String pubkey, String? query})>((ref, params) {
  return followersListStateProvider(params).debounced(
    debounceDuration: const Duration(milliseconds: 300),
    name: 'debouncedFollowersListState',
  );
});

/// Helper to get the notifier for the original entities provider
Provider<PagedNotifier> followersNotifierProvider(String pubkey, {String? query}) {
  return Provider<PagedNotifier>((ref) {
    final dataSource = ref.read(followersDataSourceProvider(pubkey, query: query));
    return ref.read(entitiesPagedDataProvider(dataSource).notifier);
  });
} 