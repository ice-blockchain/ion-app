// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/providers/counters/replied_events_provider.c.dart';
import 'package:ion/app/features/feed/providers/counters/replies_count_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/replies_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_articles_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/user_posts_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/user_replies_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/user_videos_data_source_provider.c.dart';
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

  await _deleteFromServer(ref, entity);
  await _deleteFromDataSources(ref, entity);
}

Future<void> _deleteFromServer(Ref ref, IonConnectEntity entity) async {
  final entityKind = switch (entity) {
    ModifiablePostEntity() => ModifiablePostEntity.kind,
    ArticleEntity() => ArticleEntity.kind,
    GenericRepostEntity() => GenericRepostEntity.kind,
    _ => throw DeleteEntityUnsupportedTypeException(),
  };

  final deletionRequest = DeletionRequest(
    events: [EventToDelete(eventId: entity.id, kind: entityKind)],
  );
  await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(deletionRequest, cache: false);
}

Future<void> _deleteFromDataSources(Ref ref, IonConnectEntity entity) async {
  if (entity case final ModifiablePostEntity post when post.data.parentEvent != null) {
    await _deleteReply(ref, post);
  } else if (entity case final ArticleEntity _) {
    await _deleteArticle(ref, entity);
  } else {
    await _deletePost(ref, entity);
  }
}

Future<void> _deleteReply(Ref ref, ModifiablePostEntity post) async {
  final dataSource = ref.watch(userRepliesDataSourceProvider(post.masterPubkey)) ?? [];

  final parentEventReference = post.data.parentEvent!.eventReference;

  ref.read(repliesCountProvider(parentEventReference).notifier).removeOne();

  await ref.read(repliesProvider(parentEventReference).notifier).deleteReply(entity: post);

  ref.read(repliedEventsProvider.notifier).removeReply(parentEventReference.toString(), post.id);

  await _deleteFromDataSource(ref, dataSource, post);
  ref.read(ionConnectCacheProvider.notifier).remove(post.cacheKey);
}

Future<void> _deleteArticle(Ref ref, CacheableEntity entity) async {
  final userArticlesDataSource = ref.watch(userArticlesDataSourceProvider(entity.masterPubkey));
  final feedDataSources = ref.watch(feedPostsDataSourceProvider) ?? [];

  await _deleteFromDataSource(ref, userArticlesDataSource ?? [], entity);
  await _deleteFromDataSource(ref, feedDataSources, entity);
  ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);
}

Future<void> _deletePost(Ref ref, IonConnectEntity entity) async {
  final userVideosDataSource = ref.watch(userVideosDataSourceProvider(entity.masterPubkey));
  final userPostsDataSource = ref.watch(userPostsDataSourceProvider(entity.masterPubkey));
  final feedDataSources = ref.watch(feedPostsDataSourceProvider) ?? [];

  await _deleteFromDataSource(ref, userVideosDataSource ?? [], entity);
  await _deleteFromDataSource(ref, userPostsDataSource ?? [], entity);
  await _deleteFromDataSource(ref, feedDataSources, entity);
  if (entity is CacheableEntity) {
    ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);
  }
}

Future<void> _deleteFromDataSource(
  Ref ref,
  List<EntitiesDataSource> dataSource,
  IonConnectEntity entity,
) async {
  await ref.read(entitiesPagedDataProvider(dataSource).notifier).deleteEntity(entity);
}
