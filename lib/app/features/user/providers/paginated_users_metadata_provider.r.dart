// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.r.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paginated_users_metadata_provider.r.g.dart';

typedef UserRelaysInfoFetcher = Future<List<UserRelaysInfo>> Function(
  int limit,
  int offset,
  List<UserMetadataEntity> current,
  IONIdentityClient ionIdentityClient,
);

class PaginatedUsersMetadataData {
  const PaginatedUsersMetadataData({
    this.items = const [],
    this.hasMore = true,
  });

  final List<UserMetadataEntity> items;
  final bool hasMore;
}

@Riverpod(keepAlive: true)
class PaginatedUsersMetadata extends _$PaginatedUsersMetadata {
  static const int _limit = 20;
  late UserRelaysInfoFetcher _fetcher;
  bool _initialized = false;
  int _offset = 0;

  @override
  Future<PaginatedUsersMetadataData> build(UserRelaysInfoFetcher fetcher) async {
    _fetcher = fetcher;
    if (!_initialized) {
      await _init();
      return state.value ?? const PaginatedUsersMetadataData();
    }
    return const PaginatedUsersMetadataData();
  }

  Future<void> loadMore() async {
    final hasMore = state.valueOrNull?.hasMore ?? true;
    if (state.isLoading || !hasMore) {
      return;
    }
    return _fetch();
  }

  Future<void> _init() async {
    _initialized = true;
    return _fetch();
  }

  Future<void> _fetch() async {
    state = const AsyncValue.loading();
    final currentData = state.valueOrNull?.items ?? <UserMetadataEntity>[];
    state = await AsyncValue.guard(() async {
      final ionIdentityClient = await ref.watch(ionIdentityClientProvider.future);
      final userRelaysInfo = await _fetcher(_limit, _offset, currentData, ionIdentityClient);

      final masterPubkeys = userRelaysInfo.map((e) => e.masterPubKey).toSet();
      final usersMetadataWithDependencies = await ref.read(ionConnectEntitiesManagerProvider.notifier).fetch(
            eventReferences: masterPubkeys
                .map(
                  (masterPubkey) => ReplaceableEventReference(
                    masterPubkey: masterPubkey,
                    kind: UserMetadataEntity.kind,
                  ),
                )
                .toList(),
            search: ProfileBadgesSearchExtension(forKind: UserMetadataEntity.kind).toString(),
          );

      final merged = [
        ...currentData,
        ...usersMetadataWithDependencies.whereType<UserMetadataEntity>(),
      ];
      return PaginatedUsersMetadataData(items: merged, hasMore: userRelaysInfo.length == _limit);
    });
    _offset += _limit;
  }
}

Future<List<UserRelaysInfo>> contentCreatorsPaginatedFetcher(
  int limit,
  _,
  List<UserMetadataEntity> current,
  IONIdentityClient ionIdentityClient,
) {
  return ionIdentityClient.users.getContentCreators(
    limit: limit,
    excludeMasterPubKeys: current.map((u) => u.masterPubkey).toList(),
  );
}
