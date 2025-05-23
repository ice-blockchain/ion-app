// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_creators_data_source_provider.c.g.dart';

class ContentCreatorsData {
  const ContentCreatorsData({
    this.items = const [],
    this.hasMore = true,
  });

  final List<UserMetadataEntity> items;
  final bool hasMore;
}

@Riverpod(keepAlive: true)
class ContentCreators extends _$ContentCreators {
  static const int _limit = 20;
  bool _isFetching = false;

  @override
  Future<ContentCreatorsData> build() async {
    unawaited(Future.microtask(fetch));
    return const ContentCreatorsData();
  }

  Future<void> fetch() async {
    final hasMore = state.valueOrNull?.hasMore ?? true;
    if (!hasMore || _isFetching) {
      return;
    }
    _isFetching = true;
    state = const AsyncValue.loading();
    final currentData = state.valueOrNull?.items ?? <UserMetadataEntity>[];

    try {
      final ionIdentityClient = await ref.watch(ionIdentityClientProvider.future);
      final creators = await ionIdentityClient.users.getContentCreators(
        limit: _limit,
        excludeMasterPubKeys: currentData.map((data) => data.masterPubkey).toList(),
      );

      final client = ref.read(ionConnectNotifierProvider.notifier);
      final metas = await Future.wait(
        creators.map((creator) async {
          // Try each relay in random order until we get metadata
          for (final relay in creator.ionConnectRelays.toList()..shuffle()) {
            final entityEventReference = ReplaceableEventReference(
              pubkey: creator.masterPubKey,
              kind: UserMetadataEntity.kind,
            );
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
      state = AsyncValue.data(
        ContentCreatorsData(items: merged, hasMore: creators.length == _limit),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isFetching = false;
    }
  }
}
