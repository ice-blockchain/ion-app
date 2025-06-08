// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/user_articles_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/user_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/user_replies_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/user_videos_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/entities_paged_data_models.c.dart';
import 'package:ion/app/features/user/data/models/tab_entity_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tab_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? tabDataSource(
  Ref ref, {
  required TabEntityType type,
  required String pubkey,
}) {
  switch (type) {
    case TabEntityType.posts:
      return ref.watch(userPostsDataSourceProvider(pubkey));
    case TabEntityType.articles:
      return ref.watch(userArticlesDataSourceProvider(pubkey));
    case TabEntityType.replies:
      return ref.watch(userRepliesDataSourceProvider(pubkey));
    case TabEntityType.videos:
      return ref.watch(userVideosDataSourceProvider(pubkey));
  }
}
