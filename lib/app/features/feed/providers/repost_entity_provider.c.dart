// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repost_entity_provider.c.g.dart';

@riverpod
CacheableEntity? repostEntity(Ref ref, EventReference eventReference) {
  if (eventReference is! ImmutableEventReference) {
    //TODO:replaceable handle replaceable references
    throw UnimplementedError();
  }

  final cache = ref.read(ionConnectCacheProvider);

  return cache.values.firstWhereOrNull(
    (entity) => entity is RepostEntity && entity.data.eventId == eventReference.eventId,
  );
}
