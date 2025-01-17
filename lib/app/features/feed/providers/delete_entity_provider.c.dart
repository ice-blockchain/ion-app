// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/replies_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_articles_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/user_posts_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/user_replies_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/user_videos_data_source_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_entity_provider.c.g.dart';

@riverpod
class DeleteEntity extends _$DeleteEntity {
  @override
  Future<void> build(CacheableEntity entity) async {
    return;
  }

  Future<void> delete() async {
    await _deleteFromServer();
    await _deleteFromDataSources();
  }

  Future<void> _deleteFromServer() async {
    final entityKind = switch (entity) {
      PostEntity() => PostEntity.kind,
      ArticleEntity() => ArticleEntity.kind,
      RepostEntity() => RepostEntity.kind,
      GenericRepostEntity() => GenericRepostEntity.kind,
      _ => throw DeleteEntityUnsupportedTypeException(),
    };

    final deletionRequest = DeletionRequest(
      events: [EventToDelete(eventId: entity.id, kind: entityKind)],
    );
    await ref
        .read(ionConnectNotifierProvider.notifier)
        .sendEntityData(deletionRequest, cache: false);
    ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);
  }

  Future<void> _deleteFromDataSources() async {
    if (entity case final PostEntity post when post.data.parentEvent != null) {
      await _deleteReply(post);
    } else if (entity case final ArticleEntity _) {
      await _deleteArticle();
    } else {
      await _deletePost();
    }
  }

  Future<void> _deleteReply(PostEntity post) async {
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

    final dataSource = ref.watch(userRepliesDataSourceProvider(entity.masterPubkey)) ?? [];
    await _deleteFromDataSource(dataSource);
  }

  Future<void> _deleteArticle() async {
    final userArticlesDataSource = ref.watch(userArticlesDataSourceProvider(entity.masterPubkey));
    final feedDataSources = ref.watch(feedPostsDataSourceProvider) ?? [];

    await _deleteFromDataSource(userArticlesDataSource ?? []);
    await _deleteFromDataSource(feedDataSources);
  }

  Future<void> _deletePost() async {
    final userVideosDataSource = ref.watch(userVideosDataSourceProvider(entity.masterPubkey));
    final userPostsDataSource = ref.watch(userPostsDataSourceProvider(entity.masterPubkey));
    final feedDataSources = ref.watch(feedPostsDataSourceProvider) ?? [];

    await _deleteFromDataSource(userVideosDataSource ?? []);
    await _deleteFromDataSource(userPostsDataSource ?? []);
    await _deleteFromDataSource(feedDataSources);
  }

  Future<void> _deleteFromDataSource(List<EntitiesDataSource> dataSource) async {
    await ref.read(entitiesPagedDataProvider(dataSource).notifier).deleteEntity(entity);
  }
}
