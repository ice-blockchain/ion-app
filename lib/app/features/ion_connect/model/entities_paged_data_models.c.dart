// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/model/paged.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';

part 'entities_paged_data_models.c.freezed.dart';

@freezed
class EntitiesDataSource with _$EntitiesDataSource {
  const factory EntitiesDataSource({
    required ActionSource actionSource,
    required List<RequestFilter> requestFilters,
    required bool Function(IonConnectEntity entity) entityFilter,
    bool Function(IonConnectEntity entity)? pagedFilter,
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
