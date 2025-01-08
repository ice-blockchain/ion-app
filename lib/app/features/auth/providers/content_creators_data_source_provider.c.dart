// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_creators_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource> contentCreatorsDataSource(Ref ref) {
  return [
    EntitiesDataSource(
      actionSource: const ActionSourceIndexers(),
      entityFilter: (entity) => entity is UserMetadataEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [UserMetadataEntity.kind],
          search: DiscoveryCreatorsSearchExtension().toString(),
          limit: 20,
        ),
      ],
    ),
  ];
}
