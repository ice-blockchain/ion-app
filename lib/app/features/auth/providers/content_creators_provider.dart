// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/paged.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_creators_provider.g.dart';

@riverpod
class ContentCreators extends _$ContentCreators {
  @override
  Paged<String> build() {
    return Paged.data({}, pagination: PaginationParams());
  }

  Future<void> fetchCreators() async {
    if (state is PagedLoading) {
      return;
    }

    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [UserMetadataEntity.kind],
          //TODO: uncomment when our relays are used
          // search: DiscoveryCreatorsSearchExtension().toString(),
          until: state.pagination.until,
          limit: 20,
        ),
      );

    state = Paged.loading(state.items, pagination: state.pagination);

    final entitiesStream = ref
        .read(nostrNotifierProvider.notifier)
        .requestEntities(requestMessage, actionSource: const ActionSourceIndexers());

    DateTime? lastEventTime;
    await for (final entity in entitiesStream) {
      lastEventTime = entity.createdAt;
      state = Paged.loading({...state.items}..add(entity.pubkey), pagination: state.pagination);
    }

    state = Paged.data(
      state.items,
      pagination: PaginationParams(
        hasMore: lastEventTime != null,
        lastEventTime: lastEventTime ?? state.pagination.lastEventTime,
      ),
    );
  }
}
