// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/paged.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entities_paged_data_provider.c.freezed.dart';
part 'entities_paged_data_provider.c.g.dart';

@freezed
class EntitiesDataSource with _$EntitiesDataSource {
  const factory EntitiesDataSource({
    required ActionSource actionSource,
    required List<RequestFilter> requestFilters,
    required bool Function(IonConnectEntity entity) entityFilter,
  }) = _EntitiesDataSource;
}

@freezed
class EntitiesPagedDataState with _$EntitiesPagedDataState {
  factory EntitiesPagedDataState({
    // Processing pagination params per data source
    required Paged<IonConnectEntity, Map<ActionSource, PaginationParams>> data,
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

  void deleteEntity(IonConnectEntity entity) {
    final items = state?.data.items;
    if (items == null) return;

    final updatedItems = {...items};
    final removed = updatedItems.remove(entity);

    if (removed) {
      state = state!.copyWith(
        data: state!.data.copyWith(items: updatedItems),
      );
    }
  }

  void insertEntity(IonConnectEntity entity, {int index = 0}) {
    final items = state?.data.items?.toList() ?? []
      ..insert(index, entity);
    state = state!.copyWith(
      data: state!.data.copyWith(items: items.toSet()),
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

    final entitiesStream = ref.read(ionConnectNotifierProvider.notifier).requestEntities(
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
