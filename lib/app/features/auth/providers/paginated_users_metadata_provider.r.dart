// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
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

      final client = ref.read(ionConnectNotifierProvider.notifier);
      final metas = await Future.wait(
        userRelaysInfo.map((creator) async {
          // Try each relay in random order until we get metadata
          for (final relay in creator.ionConnectRelays.toList()..shuffle()) {
            final entityEventReference = ReplaceableEventReference(
              masterPubkey: creator.masterPubKey,
              kind: UserMetadataEntity.kind,
            );
            final cachedEntity =
                ref.read(ionConnectCachedEntityProvider(eventReference: entityEventReference));
            if (cachedEntity != null) {
              return cachedEntity;
            }
            final requestMessage = RequestMessage()
              ..addFilter(
                RequestFilter(
                  kinds: const [UserMetadataEntity.kind],
                  authors: [creator.masterPubKey],
                  search: ProfileBadgesSearchExtension(forKind: UserMetadataEntity.kind).toString(),
                  limit: 1,
                ),
              );
            final entity = await client.requestEntity(
              requestMessage,
              actionSource: ActionSourceRelayUrl(relay),
              entityEventReference: entityEventReference,
            ) as UserMetadataEntity?;
            if (entity != null) {
              return entity;
            }
          }

          // All relays exhausted without success
          return null;
        }),
      );

      final merged = [
        ...currentData,
        ...metas.whereType<UserMetadataEntity>(),
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
