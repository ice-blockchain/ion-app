// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
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

    final subscription = ref
        .watch(createModifyPostNotifierStreamProvider)
        .where(_isPost)
        .distinct()
        .listen(_handlePost);
    ref.onDispose(subscription.cancel);

    return entitiesPagedData;
  }

  bool _isPost(IonConnectEntity entity) {
    return entity is ModifiablePostEntity && entity.data.parentEvent?.eventReference == null;
  }

  Future<void> loadMore() async {
    final dataSource = ref.read(feedPostsDataSourceProvider);
    await ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
  }

  void _handlePost(IonConnectEntity entity) {
    final items = Set<IonConnectEntity>.of(state?.data.items ?? {})
      ..removeWhere((existing) => existing.toEventReference() == entity.toEventReference());
    state = state?.copyWith.data(items: {entity, ...items});
  }
}
