// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relevant_followers_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? relevantFollowersDataSource(Ref ref, String pubkey, {int? limit = 3}) {
  return [
    EntitiesDataSource(
      actionSource: ActionSourceUser(pubkey),
      entityFilter: (entity) => entity is UserMetadataEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [UserMetadataEntity.kind],
          tags: {
            '#p': [pubkey],
          },
          search: SearchExtensions(
            [
              MostRelevantFollowersSearchExtension(),
            ],
          ).toString(),
          limit: limit,
        ),
      ],
    ),
  ];
}
