// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/paged.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/entities_paged_data_models.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'entities_paged_data_provider.c.g.dart';

abstract class PagedNotifier {
  Future<void> fetchEntities();
  void refresh();
  void insertEntity(IonConnectEntity entity);
  void deleteEntity(IonConnectEntity entity);
}

mixin DelegatedPagedNotifier implements PagedNotifier {
  @override
  Future<void> fetchEntities() async {
    return getDelegate().fetchEntities();
  }

  @override
  void refresh() {
    return getDelegate().refresh();
  }

  @override
  void insertEntity(IonConnectEntity entity) {
    getDelegate().insertEntity(entity);
  }

  @override
  void deleteEntity(IonConnectEntity entity) {
    getDelegate().insertEntity(entity);
  }

  PagedNotifier getDelegate();
}

@riverpod
class EntitiesPagedData extends _$EntitiesPagedData implements PagedNotifier {
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

  @override
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

  @override
  void refresh() {
    ref.invalidateSelf();
  }

  @override
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

  @override
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
        filter.copyWith(until: () => paginationParams.until?.microsecondsSinceEpoch),
      );
    }

    final entitiesStream = ref.read(ionConnectNotifierProvider.notifier).requestEntities(
          requestMessage,
          actionSource: dataSource.actionSource,
        );

    DateTime? lastEventTime;
    final pagedFilter = dataSource.pagedFilter ?? dataSource.entityFilter;

    await for (final entity in entitiesStream) {
      final stateFilter = !(state?.data.items?.contains(entity)).falseOrValue;

      // Update pagination params
      if (pagedFilter(entity) && stateFilter) {
        lastEventTime = entity.createdAt.toDateTime;
      }

      // Update state
      if (dataSource.entityFilter(entity) && stateFilter) {
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
