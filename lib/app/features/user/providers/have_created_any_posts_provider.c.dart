// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/providers/user_posts_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'have_created_any_posts_provider.c.g.dart';

@riverpod
Future<bool?> haveCreatedAnyPosts(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return false;
  }

  final dataSource = ref.watch(userPostsDataSourceProvider(currentPubkey));
  final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
  final entities = entitiesPagedData?.data.items;
  if (entities == null) {
    return null;
  }
  return entities.isNotEmpty;
}
