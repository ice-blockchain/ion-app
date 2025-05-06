// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_creators_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource> contentCreatorsDataSource(Ref ref) {
  final relay = ref.watch(envProvider.notifier).get<String>(EnvVariable.CONTENT_CREATORS_RELAY);
  return [
    EntitiesDataSource(
      actionSource: ActionSourceRelayUrl(relay),
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
