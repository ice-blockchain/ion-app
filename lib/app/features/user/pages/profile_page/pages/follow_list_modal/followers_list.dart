// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/debounced_provider_wrapper.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.r.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.r.dart';

// Create a provider that gives us the entities list for a given query
final _followersEntitiesProvider = Provider.family<List<UserMetadataEntity>?, ({String pubkey, String? query})>((ref, params) {
  final dataSource = ref.watch(followersDataSourceProvider(params.pubkey, query: params.query));
  final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
  return entitiesPagedData?.data.items?.whereType<UserMetadataEntity>().toList();
});

/// Throttled stream provider for the entities list
final throttledFollowersEntitiesProvider = StreamProvider.family<List<UserMetadataEntity>?, ({String pubkey, String? query})>((ref, params) async* {
  final provider = _followersEntitiesProvider(params);
  List<UserMetadataEntity>? lastValue;
  final controller = StreamController<List<UserMetadataEntity>?>();
  Timer? throttleTimer;
  bool hasPending = false;

  void emitThrottled() {
    if (throttleTimer == null || !throttleTimer!.isActive) {
      controller.add(lastValue);
      throttleTimer = Timer(const Duration(milliseconds: 200), () {
        if (hasPending) {
          controller.add(lastValue);
          hasPending = false;
          throttleTimer = Timer(const Duration(milliseconds: 200), emitThrottled);
        } else {
          throttleTimer = null;
        }
      });
    } else {
      hasPending = true;
    }
  }

  final sub = ref.listen<List<UserMetadataEntity>?>(provider, (prev, next) {
    lastValue = next;
    emitThrottled();
  });

  // Emit initial value
  lastValue = ref.read(provider);
  emitThrottled();

  yield* controller.stream;

  ref.onDispose(() {
    throttleTimer?.cancel();
    controller.close();
    sub.close();
  });
});

class FollowersList extends HookConsumerWidget {
  const FollowersList({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersCount = ref.watch(followersCountProvider(pubkey)).valueOrNull;

    final searchQuery = useState('');
    final debouncedQuery = useDebounced(searchQuery.value, const Duration(milliseconds: 300)) ?? '';

    // Use the throttled stream provider for the entities list
    final entitiesAsync = ref.watch(throttledFollowersEntitiesProvider((pubkey: pubkey, query: debouncedQuery.isEmpty ? null : debouncedQuery)));
    final entities = entitiesAsync.value;

    // For load more, we need the current data source (non-debounced for actions)
    final currentDataSource = ref.watch(followersDataSourceProvider(pubkey, query: debouncedQuery.isEmpty ? null : debouncedQuery));
    final currentEntitiesPagedData = ref.watch(entitiesPagedDataProvider(currentDataSource));

    final slivers = [
      FollowAppBar(title: FollowType.followers.getTitleWithCounter(context, followersCount ?? 0)),
      FollowSearchBar(onTextChanged: (query) => searchQuery.value = query),
      if (entities == null)
        const FollowListLoading()
      else if (entities.isEmpty)
        const NothingIsFound()
      else
        SliverList.builder(
          itemCount: entities.length,
          itemBuilder: (context, index) => ScreenSideOffset.small(
            child: FollowListItem(pubkey: entities[index].masterPubkey),
          ),
        ),
      SliverPadding(padding: EdgeInsetsDirectional.only(bottom: 32.0.s)),
    ];

    return LoadMoreBuilder(
      slivers: slivers,
      hasMore: currentEntitiesPagedData?.hasMore ?? false,
      onLoadMore: () => ref.read(entitiesPagedDataProvider(currentDataSource).notifier).fetchEntities(),
    );
  }
}
