// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_provider.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/user_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/user_videos_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_entity_provider.c.g.dart';

@riverpod
Future<void> deleteEntity(
  Ref ref,
  EventReference eventReference,
) async {
  final entity = await ref.read(ionConnectEntityProvider(eventReference: eventReference).future);
  if (entity == null) {
    throw EntityNotFoundException(eventReference);
  }

  switch (entity) {
    case GenericRepostEntity() || RepostEntity() || PostEntity():
      {
        await _deleteFromServer(ref, entity);
        _deleteFromDataSources(ref, entity);
        _deleteFromCache(ref, entity);
      }
    case ModifiablePostEntity():
      {
        await ref
            .read(createPostNotifierProvider(CreatePostOption.softDelete).notifier)
            .softDelete(eventReference: eventReference);
      }
    case ArticleEntity():
      {
        await ref.read(createArticleProvider.notifier).softDelete(eventReference: eventReference);
      }
    default:
      {
        throw DeleteEntityUnsupportedTypeException();
      }
  }
}

Future<void> _deleteFromServer(Ref ref, IonConnectEntity entity) async {
  final entityKind = switch (entity) {
    RepostEntity() => RepostEntity.kind,
    GenericRepostEntity() => GenericRepostEntity.kind,
    _ => throw DeleteEntityUnsupportedTypeException(),
  };

  final deletionRequest = DeletionRequest(
    events: [EventToDelete(eventId: entity.id, kind: entityKind)],
  );
  await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(deletionRequest, cache: false);
}

void _deleteFromDataSources(Ref ref, IonConnectEntity entity) {
  final dataSources = [
    ref.read(userVideosDataSourceProvider(entity.masterPubkey)),
    ref.read(userPostsDataSourceProvider(entity.masterPubkey)),
    ref.read(feedPostsDataSourceProvider),
  ];

  for (final dataSource in dataSources) {
    ref.read(entitiesPagedDataProvider(dataSource).notifier).deleteEntity(entity);
  }
}

void _deleteFromCache(Ref ref, IonConnectEntity entity) {
  if (entity is CacheableEntity) {
    ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);
  }
}
