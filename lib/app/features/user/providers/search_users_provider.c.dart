// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_users_provider.c.g.dart';

@riverpod
class SearchUsers extends _$SearchUsers {
  @override
  ({List<UserMetadataEntity> users, bool hasMore, List<EntitiesDataSource> dataSource})? build({
    required String query,
  }) {
    if (query.isEmpty) return null;

    final masterPubkey = ref.watch(currentPubkeySelectorProvider);
    final dataSource = ref.watch(searchUsersDataSourceProvider(query: query));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));

    if (entitiesPagedData == null) {
      return null;
    }

    final users = entitiesPagedData.data.items
            ?.whereType<UserMetadataEntity>()
            .whereNot((user) => user.masterPubkey == masterPubkey)
            .toList() ??
        [];
    return (users: users, hasMore: entitiesPagedData.hasMore, dataSource: dataSource);
  }

  Future<void> loadMore() async {
    final dataSource = state?.dataSource;
    if (dataSource != null) {
      return ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
    }
  }

  Future<void> refresh() async {
    final dataSource = state?.dataSource;
    if (dataSource != null) {
      return ref.invalidate(entitiesPagedDataProvider(dataSource));
    }
  }
}

@riverpod
List<EntitiesDataSource> searchUsersDataSource(Ref ref, {required String query}) {
  return [
    EntitiesDataSource(
      actionSource: const ActionSourceIndexers(),
      entityFilter: (entity) => entity is UserMetadataEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [UserMetadataEntity.kind],
          search: SearchExtensions(
            [
              QuerySearchExtension(searchQuery: query),
            ],
          ).toString(),
          limit: 20,
        ),
      ],
    ),
  ];
}

@riverpod
class SearchUsersQuery extends _$SearchUsersQuery {
  @override
  String build() {
    return '';
  }

  set text(String value) {
    state = value;
  }
}
