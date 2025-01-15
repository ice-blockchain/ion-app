// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/replies_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_entity_provider.c.g.dart';

@riverpod
class DeleteEntity extends _$DeleteEntity {
  @override
  Future<void> build(CacheableEntity entity) async {
    return;
  }

  Future<void> delete() async {
    final entityKind = switch (entity) {
      PostEntity() => PostEntity.kind,
      ArticleEntity() => ArticleEntity.kind,
      _ => throw DeleteEntityUnsupportedTypeException(),
    };

    final deletionRequest = DeletionRequest(
      events: [EventToDelete(eventId: entity.id, kind: entityKind)],
    );

    await ref
        .read(ionConnectNotifierProvider.notifier)
        .sendEntityData(deletionRequest, cache: false);

    ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);

    if (entity case final PostEntity post when post.data.parentEvent != null) {
      // Post reply
      await ref
          .read(
            repliesProvider(
              EventReference(
                eventId: post.data.parentEvent!.eventId,
                pubkey: post.data.parentEvent!.pubkey,
              ),
            ).notifier,
          )
          .deleteReply(entity: entity);
    } else {
      // Post or Article
      final feedDataSources = ref.read(feedPostsDataSourceProvider) ?? [];
      if (feedDataSources.isNotEmpty) {
        await ref.read(entitiesPagedDataProvider(feedDataSources).notifier).deleteEntity(entity);
      }
    }
  }
}
