// SPDX-License-Identifier: ice License 1.0

import 'package:async/async.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_provider.c.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_entity_provider.c.dart';
import 'package:ion/app/features/feed/providers/repost_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_posts_provider.c.g.dart';

@riverpod
class FeedPosts extends _$FeedPosts {
  @override
  EntitiesPagedDataState? build() {
    final dataSource = ref.watch(feedPostsDataSourceProvider);
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));

    final postsStream = ref.watch(createPostNotifierStreamProvider);
    final articlesStream = ref.watch(createArticleNotifierStreamProvider);
    final repostsStream = ref.watch(createRepostNotifierStreamProvider);
    final subscription = StreamGroup.merge([postsStream, articlesStream, repostsStream])
        .where(_filterEntities)
        .distinct()
        .listen(_handleEntity);
    ref.onDispose(subscription.cancel);

    return entitiesPagedData;
  }

  bool _filterEntities(IonConnectEntity entity) {
    final currentCategory = ref.read(feedCurrentFilterProvider).category;
    switch (currentCategory) {
      case FeedCategory.feed:
        return _isRegularPostOrRepost(entity) || _isArticleOrArticleRepost(entity);
      case FeedCategory.videos:
        final isVideoPost = _isVideoPost(entity);
        final isVideoRepost = _isVideoRepost(entity);
        return isVideoPost || isVideoRepost;
      case FeedCategory.articles:
        return _isArticleOrArticleRepost(entity);
    }
  }

  Future<void> loadMore() async {
    final dataSource = ref.read(feedPostsDataSourceProvider);
    await ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
  }

  void _handleEntity(IonConnectEntity entity) {
    final dataSource = ref.read(feedPostsDataSourceProvider);
    ref.read(entitiesPagedDataProvider(dataSource).notifier).insertEntity(entity);
  }

  bool _isVideoPost(IonConnectEntity entity) {
    if (entity is ModifiablePostEntity) {
      return entity.data.parentEvent?.eventReference == null &&
          entity.data.expiration == null &&
          entity.data.media.values.any((media) => media.mediaType == MediaType.video);
    }
    return false;
  }

  bool _isRegularPostOrRepost(IonConnectEntity entity) {
    final isRegularPost = entity is ModifiablePostEntity &&
        entity.data.parentEvent?.eventReference == null &&
        entity.data.expiration == null;
    final isPostRepost = _isPostRepost(entity);
    return isRegularPost || isPostRepost;
  }

  bool _isPostRepost(IonConnectEntity entity) {
    final repostedEntity = _repostedEntity(entity);
    return repostedEntity != null &&
        (repostedEntity is ModifiablePostEntity || repostedEntity is PostEntity);
  }

  bool _isArticleOrArticleRepost(IonConnectEntity entity) {
    return entity is ArticleEntity || _isArticleRepost(entity);
  }

  bool _isArticleRepost(IonConnectEntity entity) {
    final repostedEntity = _repostedEntity(entity);
    return repostedEntity != null && repostedEntity is ArticleEntity;
  }

  bool _isVideoRepost(IonConnectEntity entity) {
    final repostedEntity = _repostedEntity(entity);

    if (repostedEntity is ModifiablePostEntity) {
      return repostedEntity.data.parentEvent?.eventReference == null &&
          repostedEntity.data.expiration == null &&
          repostedEntity.data.media.values.any((media) => media.mediaType == MediaType.video);
    }
    return false;
  }

  IonConnectEntity? _repostedEntity(IonConnectEntity entity) {
    EventReference? repostedEventReference;
    if (entity is GenericRepostEntity) {
      repostedEventReference = entity.data.eventReference;
    } else if (entity is RepostEntity) {
      repostedEventReference = entity.data.eventReference;
    }

    if (repostedEventReference == null) return null;
    return ref.read(
      feedEntityProvider(eventReference: repostedEventReference),
    );
  }
}
