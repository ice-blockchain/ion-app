// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/paged.dart';
import 'package:ion/app/features/feed/data/models/entities/mocked_counters.dart';
import 'package:ion/app/features/feed/providers/fake_posts_generator.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entities_paged_data_provider.freezed.dart';
part 'entities_paged_data_provider.g.dart';

@freezed
class EntitiesDataSource with _$EntitiesDataSource {
  const factory EntitiesDataSource({
    required ActionSource actionSource,
    required List<RequestFilter> requestFilters,
    required bool Function(NostrEntity entity) entityFilter,
  }) = _EntitiesDataSource;
}

@freezed
class EntitiesPagedDataState with _$EntitiesPagedDataState {
  factory EntitiesPagedDataState({
    // Processing pagination params per data source
    required Paged<NostrEntity, Map<ActionSource, PaginationParams>> data,
  }) = _EntitiesPagedDataState;

  EntitiesPagedDataState._();

  bool get hasMore => data.pagination.values.any((params) => params.hasMore);
}

@riverpod
class EntitiesPagedData extends _$EntitiesPagedData {
  @override
  EntitiesPagedDataState? build(List<EntitiesDataSource>? dataSources) {
    if (dataSources != null) {
      Future.microtask(fetchEntities);

      return EntitiesPagedDataState(
        data: Paged.data(
          null,
          pagination: {for (final source in dataSources) source.actionSource: PaginationParams()},
        ),
      );
    }
    return null;
  }

  Future<void> fetchEntities() async {
    final currentState = state;

    if (dataSources == null || currentState == null || currentState.data is PagedLoading) {
      return;
    }

    state = currentState.copyWith(
      data: Paged.loading(currentState.data.items, pagination: currentState.data.pagination),
    );

    final paginationEntries = await Future.wait(
      dataSources!.map(_fetchEntitiesFromDataSource),
    );

    state = state?.copyWith(
      data: Paged.data(
        state!.data.items ?? {},
        pagination: Map.fromEntries(paginationEntries),
      ),
    );
  }

  Future<MapEntry<ActionSource, PaginationParams>> _fetchEntitiesFromDataSource(
    EntitiesDataSource dataSource,
  ) async {
    final currentState = state;
    final paginationParams = state?.data.pagination[dataSource.actionSource];

    if (currentState == null || paginationParams == null || !paginationParams.hasMore) {
      return MapEntry(dataSource.actionSource, PaginationParams(hasMore: false));
    }

    final requestMessage = RequestMessage();
    for (final filter in dataSource.requestFilters) {
      requestMessage.addFilter(
        filter.copyWith(until: () => paginationParams.until),
      );
    }

    final entitiesStream = ref.read(nostrNotifierProvider.notifier).requestEntities(
          requestMessage,
          actionSource: dataSource.actionSource,
        );

    DateTime? lastEventTime;
    await for (final entity in entitiesStream) {
      if (dataSource.entityFilter(entity) && !(state?.data.items?.contains(entity)).falseOrValue) {
        lastEventTime = entity.createdAt;
        state = state?.copyWith(
          data: Paged.loading(
            {...state!.data.items ?? {}}..add(entity),
            pagination: state!.data.pagination,
          ),
        );
      }
    }

    return MapEntry(
      dataSource.actionSource,
      PaginationParams(hasMore: lastEventTime != null, lastEventTime: lastEventTime),
    );
  }
}

// TODO: remove [MockPostEntitiesPagedData] when real relay data will be ready
@riverpod
class MockPostEntitiesPagedData extends _$MockPostEntitiesPagedData {
  @override
  EntitiesPagedDataState? build(List<EntitiesDataSource>? dataSources) {
    if (dataSources != null) {
      Future.microtask(fetchEntities);

      return EntitiesPagedDataState(
        data: Paged.data(
          {},
          pagination: {for (final source in dataSources) source.actionSource: PaginationParams()},
        ),
      );
    }
    return null;
  }

  Future<void> fetchEntities() async {
    final currentState = state;
    if (currentState == null || currentState.data is PagedLoading) {
      return;
    }

    state = currentState.copyWith(
      data: Paged.loading(currentState.data.items, pagination: currentState.data.pagination),
    );

    final mockedPosts = (await Future.wait(
      List.generate(
        dataSources!.first.requestFilters.first.limit!,
        (index) => generateFakePostWithVideo(),
      ),
    ))
        .toSet();

    final nostrCache = ref.read(nostrCacheProvider.notifier);

    for (final post in mockedPosts) {
      generateFakeCounters(ref, post.id);
      nostrCache.cache(post);
    }

    final paginationEntries = await Future.delayed(
      const Duration(milliseconds: 500),
      () => {
        for (final source in dataSources!) source.actionSource: PaginationParams(),
      },
    );

    state = state?.copyWith(
      data: Paged.data(
        {...state!.data.items ?? {}, ...mockedPosts},
        pagination: paginationEntries,
      ),
    );
  }
}
