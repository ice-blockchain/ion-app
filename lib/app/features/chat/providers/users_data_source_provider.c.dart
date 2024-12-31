// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_data_source_provider.c.g.dart';

@riverpod
Future<List<EntitiesDataSource>> usersDataSource(Ref ref) async {
  final searchText = ref.watch(usersSearchTextProvider);

  await ref.debounce();
  return [
    EntitiesDataSource(
      actionSource: const ActionSourceIndexers(),
      entityFilter: (entity) => entity is UserMetadataEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [UserMetadataEntity.kind],
          search: searchText,
          limit: 20,
        ),
      ],
    ),
  ];
}

@riverpod
class UsersSearchText extends _$UsersSearchText {
  @override
  String build() {
    return '';
  }

  set text(String value) {
    state = value;
  }
}
