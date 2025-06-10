// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/replies_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/entities_paged_data_models.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'replies_provider.c.g.dart';

@riverpod
class Replies extends _$Replies {
  @override
  EntitiesPagedDataState? build(EventReference eventReference) {
    final dataSource = ref.watch(repliesDataSourceProvider(eventReference: eventReference));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));

    final subscription = ref
        .watch(createPostNotifierStreamProvider)
        .where((entity) => _isReply(entity, eventReference))
        .distinct()
        .listen(_handleReply);
    ref.onDispose(subscription.cancel);

    return entitiesPagedData;
  }

  bool _isReply(IonConnectEntity entity, EventReference parentEventReference) {
    return entity is ModifiablePostEntity &&
        entity.data.parentEvent?.eventReference == parentEventReference;
  }

  void _handleReply(IonConnectEntity entity) {
    final dataSource = ref.read(repliesDataSourceProvider(eventReference: eventReference));
    ref.read(entitiesPagedDataProvider(dataSource).notifier).insertEntity(entity);
  }

  Future<void> loadMore(EventReference eventReference) async {
    final dataSource = ref.read(repliesDataSourceProvider(eventReference: eventReference));
    await ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
  }
}
