// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/model/paged.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entities_paged_data_provider.g.dart';
part 'entities_paged_data_provider.freezed.dart';

@freezed
class EntitiesDataSource with _$EntitiesDataSource {
  const factory EntitiesDataSource({
    required String relayUrl,
    required RequestFilter requestFilter,
    required bool Function(NostrEntity entity) entityFilter,
  }) = _EntitiesDataSource;
}

@freezed
class EntitiesPagedDataState with _$EntitiesPagedDataState {
  const factory EntitiesPagedDataState({
    required List<EntitiesDataSource> dataSources,
    // Processing pagination params per data source
    required Paged<NostrEntity, Map<String, PaginationParams>> data,
  }) = _EntitiesPagedDataState;
}

@riverpod
class EntitiesPagedData extends _$EntitiesPagedData {
  @override
  EntitiesPagedDataState? build(List<EntitiesDataSource>? dataSources) {
    if (dataSources != null) {
      return EntitiesPagedDataState(
        dataSources: dataSources,
        data: Paged.data(
          {},
          pagination: {for (final source in dataSources) source.relayUrl: PaginationParams()},
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

    final paginationEntries = await Future.wait(
      currentState.dataSources.map(_fetchEntitiesFromDataSource),
    );

    state = state?.copyWith(
      data: Paged.data(
        state!.data.items,
        pagination: Map.fromEntries(paginationEntries),
      ),
    );
  }

  Future<MapEntry<String, PaginationParams>> _fetchEntitiesFromDataSource(
    EntitiesDataSource dataSource,
  ) async {
    final currentState = state;
    final paginationParams = state?.data.pagination[dataSource.relayUrl];

    if (currentState == null || paginationParams == null || !paginationParams.hasMore) {
      return MapEntry(dataSource.relayUrl, PaginationParams(hasMore: false));
    }

    final requestMessage = RequestMessage()
      ..addFilter(
        dataSource.requestFilter.copyWith(
          until: () => paginationParams.until,
        ),
      );

    final entitiesStream = ref.read(nostrNotifierProvider.notifier).requestEntities(
          requestMessage,
          actionSource: ActionSourceRelayUrl(dataSource.relayUrl),
        );

    DateTime? lastEventTime;
    await for (final entity in entitiesStream) {
      if (dataSource.entityFilter(entity)) {
        lastEventTime = entity.createdAt;
        state = state?.copyWith(
          data: Paged.loading(
            {...state!.data.items}..add(entity),
            pagination: state!.data.pagination,
          ),
        );
      }
    }

    return MapEntry(
      dataSource.relayUrl,
      PaginationParams(hasMore: lastEventTime != null, lastEventTime: lastEventTime),
    );
  }
}
