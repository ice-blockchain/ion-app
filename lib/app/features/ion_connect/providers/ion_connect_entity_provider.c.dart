// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_entity_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<IonConnectEntity?> ionConnectEntity(
  Ref ref, {
  required EventReference eventReference,
  bool skipCache = false,
}) async {
  if (!skipCache) {
    final entity = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector(eventReference.eventId),
      ),
    );
    if (entity != null) {
      return entity;
    }
  }

  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(ids: [eventReference.eventId], limit: 1));
  return ref.read(ionConnectNotifierProvider.notifier).requestEntity(
        requestMessage,
        actionSource: ActionSourceUser(eventReference.pubkey),
      );
}
