// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_users_data_source_provider.c.g.dart';

@riverpod
Future<List<EntitiesDataSource>> searchUsersDataSource(Ref ref) async {
  final searchText = ref.watch(searchUsersQueryProvider);

  await ref.debounce();
  return [
    EntitiesDataSource(
      actionSource: const ActionSourceIndexers(),
      entityFilter: (entity) => entity is UserMetadataEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [UserMetadataEntity.kind],
          search: SearchExtensions(
            [
              QuerySearchExtension(searchQuery: searchText),
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
