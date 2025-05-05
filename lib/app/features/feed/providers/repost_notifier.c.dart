// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/providers/counters/reposts_count_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_events_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repost_notifier.c.g.dart';

final _createRepostNotifierStreamController = StreamController<IonConnectEntity>.broadcast();

@riverpod
Raw<Stream<IonConnectEntity>> createRepostNotifierStream(Ref ref) {
  return _createRepostNotifierStreamController.stream;
}

@riverpod
class RepostNotifier extends _$RepostNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> repost({
    required EventReference eventReference,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final entity = ref.read(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;

      if (entity == null) {
        throw EntityNotFoundException(eventReference);
      }

      final data = switch (entity) {
        PostEntity() => RepostData(
            eventReference: entity.toEventReference(),
            repostedEvent: await entity.toEventMessage(entity.data),
          ),
        ModifiablePostEntity() => GenericRepostData(
            eventReference: entity.toEventReference(),
            repostedEvent: await entity.toEventMessage(entity.data),
            kind: ModifiablePostEntity.kind,
          ),
        ArticleEntity() => GenericRepostData(
            eventReference: entity.toEventReference(),
            repostedEvent: await entity.toEventMessage(entity.data),
            kind: ArticleEntity.kind,
          ),
        _ => throw UnsupportedRepostException(entity.toEventReference()),
      };

      final userEventsMetadataBuilder = await ref.read(userEventsMetadataBuilderProvider.future);

      final (repostEntity, _) = await (
        ref.read(ionConnectNotifierProvider.notifier).sendEntityData(data),
        ref.read(ionConnectNotifierProvider.notifier).sendEntityData(
              data,
              actionSource: ActionSourceUser(eventReference.pubkey),
              metadataBuilders: [userEventsMetadataBuilder],
              cache: false,
            )
      ).wait;

      if (repostEntity != null) {
        _createRepostNotifierStreamController.add(repostEntity);
      }

      ref.read(repostsCountProvider(eventReference).notifier).addOne();
    });
  }
}
