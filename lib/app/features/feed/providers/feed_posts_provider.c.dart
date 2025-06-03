// SPDX-License-Identifier: ice License 1.0

import 'package:async/async.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/create_article/providers/create_article_provider.c.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_following_content_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.c.dart';
import 'package:ion/app/features/feed/providers/repost_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_posts_provider.c.g.dart';

@riverpod
class FeedPosts extends _$FeedPosts {
  @override
  ({Iterable<IonConnectEntity>? items, bool hasMore}) build() {
    final postsStream = ref.watch(createPostNotifierStreamProvider);
    final articlesStream = ref.watch(createArticleNotifierStreamProvider);
    final repostsStream = ref.watch(createRepostNotifierStreamProvider);
    final subscription = StreamGroup.merge([postsStream, articlesStream, repostsStream])
        .where(_filterEntities)
        .distinct()
        .listen(_insertEntity);
    ref.onDispose(subscription.cancel);

    final filter = ref.watch(feedCurrentFilterProvider);
    if (filter.filter == FeedFilter.following) {
      final feedType = FeedType.fromCategory(filter.category);
      final followingContent = ref.watch(feedFollowingContentProvider(feedType));
      return (items: followingContent.items, hasMore: followingContent.hasMore);
    } else {
      final dataSource = ref.watch(feedPostsDataSourceProvider);
      final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
      return (items: entitiesPagedData?.data.items, hasMore: entitiesPagedData?.hasMore ?? true);
    }
  }

  Future<void> loadMore() async {
    return _getNotifier().fetchEntities();
  }

  void refresh() {
    return _getNotifier().refresh();
  }

  PagedNotifier _getNotifier() {
    final filter = ref.watch(feedCurrentFilterProvider);
    if (filter.filter == FeedFilter.following) {
      final feedType = FeedType.fromCategory(filter.category);
      return ref.read(feedFollowingContentProvider(feedType).notifier);
    } else {
      final dataSource = ref.watch(feedPostsDataSourceProvider);
      return ref.read(entitiesPagedDataProvider(dataSource).notifier);
    }
  }

  bool _filterEntities(IonConnectEntity entity) {
    final currentCategory = ref.read(feedCurrentFilterProvider).category;
    return switch (currentCategory) {
      FeedCategory.feed => _isRegularPostOrRepost(entity) || _isArticleOrArticleRepost(entity),
      FeedCategory.videos =>
        ref.read(isVideoPostProvider(entity)) || ref.read(isVideoRepostProvider(entity)),
      FeedCategory.articles => _isArticleOrArticleRepost(entity),
    };
  }

  void _insertEntity(IonConnectEntity entity) {
    _getNotifier().insertEntity(entity);
  }

  bool _isRegularPostOrRepost(IonConnectEntity entity) {
    final isRegularPost = entity is ModifiablePostEntity &&
        entity.data.parentEvent?.eventReference == null &&
        entity.data.expiration == null;
    final isPostRepost = _isPostRepost(entity);
    return isRegularPost || isPostRepost;
  }

  bool _isPostRepost(IonConnectEntity entity) {
    final repostedEntity = ref.read(getRepostedEntityProvider(entity));
    return repostedEntity != null &&
        (repostedEntity is ModifiablePostEntity || repostedEntity is PostEntity);
  }

  bool _isArticleOrArticleRepost(IonConnectEntity entity) {
    return entity is ArticleEntity || _isArticleRepost(entity);
  }

  bool _isArticleRepost(IonConnectEntity entity) {
    final repostedEntity = ref.read(getRepostedEntityProvider(entity));
    return repostedEntity != null && repostedEntity is ArticleEntity;
  }
}

@riverpod
bool isVideoPost(Ref ref, IonConnectEntity entity) {
  if (entity is ModifiablePostEntity) {
    return entity.data.parentEvent?.eventReference == null &&
        entity.data.expiration == null &&
        entity.data.hasVideo;
  }
  return false;
}

@riverpod
bool isVideoRepost(Ref ref, IonConnectEntity entity) {
  final reposted = ref.read(getRepostedEntityProvider(entity));
  if (reposted is ModifiablePostEntity) {
    return reposted.data.parentEvent?.eventReference == null &&
        reposted.data.expiration == null &&
        reposted.data.hasVideo;
  }
  return false;
}

@riverpod
IonConnectEntity? getRepostedEntity(Ref ref, IonConnectEntity entity) {
  EventReference? repostedEventReference;
  if (entity is GenericRepostEntity) {
    repostedEventReference = entity.data.eventReference;
  } else if (entity is RepostEntity) {
    repostedEventReference = entity.data.eventReference;
  }
  if (repostedEventReference == null) return null;
  return ref.read(ionConnectEntityWithCountersProvider(eventReference: repostedEventReference));
}
