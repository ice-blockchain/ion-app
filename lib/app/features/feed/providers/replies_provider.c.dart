// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
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
        .where((entity) => _isReply(entity, eventReference))
        .distinct()
        .listen((entity) {
      if (state?.data.items?.any((e) => e.id == entity.id) ?? false) {
        return;
      }

      state = state?.copyWith.data(items: {entity, ...state?.data.items ?? {}});
    });
    ref.onDispose(subscription.cancel);

    return entitiesPagedData;
  }

  bool _isReply(IonConnectEntity entity, EventReference parentEventReference) {
    if (parentEventReference is! ImmutableEventReference) {
      //TODO:replaceable handle replaceable references
      throw UnimplementedError();
    }
    return entity is PostEntity && entity.data.parentEvent?.eventId == parentEventReference.eventId;
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
}
