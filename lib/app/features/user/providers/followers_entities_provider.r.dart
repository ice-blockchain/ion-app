// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_entities_provider.r.g.dart';

@riverpod
List<UserMetadataEntity>? followersEntities(
  Ref ref, {
  required String pubkey,
}) {
  final dataSource = ref.watch(followersDataSourceProvider(pubkey));
  final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
  return entitiesPagedData?.data.items?.whereType<UserMetadataEntity>().toList();
}
