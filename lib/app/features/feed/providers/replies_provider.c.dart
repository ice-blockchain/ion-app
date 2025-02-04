// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/replies_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_provider.c.g.dart';

@riverpod
class Replies extends _$Replies {
  @override
  EntitiesPagedDataState? build(EventReference eventReference) {
    final dataSource = ref.watch(repliesDataSourceProvider(eventReference: eventReference));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));

    final subscription = ref
        .watch(ionConnectCacheStreamProvider)
        .where((entity) => _isReply(entity, eventReference) && !_isPartOfState(entity))
        .distinct()
        .listen(
          (entity) => state = state?.copyWith.data(items: {entity, ...state?.data.items ?? {}}),
        );
    ref.onDispose(subscription.cancel);

    return entitiesPagedData;
  }

  bool _isReply(IonConnectEntity entity, EventReference parentEventReference) {
    return entity is ModifiablePostEntity &&
        entity.data.parentEvent?.eventReference == parentEventReference;
  }

  bool _isPartOfState(IonConnectEntity entity) {
    return state?.data.items?.any(
          (stateEntity) =>
              stateEntity is ModifiablePostEntity &&
              entity is ModifiablePostEntity &&
              stateEntity.toEventReference() == entity.toEventReference(),
        ) ??
        false;
  }

  Future<void> deleteReply({
    required CacheableEntity entity,
  }) async {
    final currentState = state;
    if (currentState != null) {
      final updatedItems =
          currentState.data.items?.where((item) => item.id != entity.id).toSet() ?? {};

      state = currentState.copyWith(
        data: currentState.data.copyWith(
          items: updatedItems,
          pagination: currentState.data.pagination,
        ),
      );
    }
  }

  Future<void> loadMore(EventReference eventReference) async {
    final dataSource = ref.read(repliesDataSourceProvider(eventReference: eventReference));
    await ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
  }
}
