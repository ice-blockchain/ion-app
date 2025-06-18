// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_parent.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_post_provider.c.g.dart';

@riverpod
IonConnectEntity? rootPostEntity(
  Ref ref, {
  required EventReference eventReference,
  bool network = true,
  bool cache = true,
}) {
  final entity = ref
      .watch(
        ionConnectEntityProvider(
          eventReference: eventReference,
          network: network,
          cache: cache,
        ),
      )
      .valueOrNull;
  if (entity == null) {
    return null;
  }
  final entityData = switch (entity) {
    ModifiablePostEntity() => entity.data,
    PostEntity() => entity.data,
    _ => null,
  };

  if (entityData is! EntityDataWithRelatedEvents?) {
    return entity;
  }

  final rootEvent = entityData?.rootRelatedEvent;
  if (rootEvent == null) {
    return entity;
  }

  return ref
      .watch(
        ionConnectEntityProvider(
          eventReference: rootEvent.eventReference,
          network: network,
          cache: cache,
        ),
      )
      .valueOrNull;
}
