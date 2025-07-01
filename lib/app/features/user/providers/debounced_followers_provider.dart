// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/paged.f.dart';
import 'package:ion/app/features/core/providers/debounced_provider_wrapper.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.r.dart';

class FollowersListState {
  const FollowersListState({
    this.entities,
    this.hasMore = false,
    // this.isLoading = false,
  });

  final List<UserMetadataEntity>? entities;
  final bool hasMore;
  // final bool isLoading;
}

final followersListStateProvider =
    Provider.family<FollowersListState, ({String pubkey, String? query})>((ref, params) {
  final dataSource = ref.watch(followersDataSourceProvider(params.pubkey, query: params.query));
  final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));

  if (entitiesPagedData == null) {
    return const FollowersListState();
  }

  final entities = entitiesPagedData.data.items?.whereType<UserMetadataEntity>().toList();

  return FollowersListState(
    entities: entities,
    hasMore: entitiesPagedData.hasMore,
  );
});

final debouncedFollowersListStateProvider = Provider.family<
    StateNotifierProvider<DebouncedNotifier<FollowersListState>, FollowersListState?>,
    ({String pubkey, String? query})>((ref, params) {
  return followersListStateProvider(params).debounced(
    debounceDuration: const Duration(milliseconds: 100),
    name: 'debouncedFollowersListState',
  );
});

Provider<PagedNotifier> followersNotifierProvider(String pubkey, {String? query}) {
  return Provider<PagedNotifier>((ref) {
    final dataSource = ref.read(followersDataSourceProvider(pubkey, query: query));
    return ref.read(entitiesPagedDataProvider(dataSource).notifier);
  });
}
