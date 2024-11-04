// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_creators_data_source_provider.g.dart';

@riverpod
List<EntitiesDataSource> contentCreatorsDataSource(Ref ref) {
  return [
    EntitiesDataSource(
      actionSource: const ActionSourceIndexers(),
      entityFilter: (entity) => entity is UserMetadataEntity,
      requestFilter: const RequestFilter(
        kinds: [UserMetadataEntity.kind],
        limit: 20,
      ),
    ),
  ];
}
