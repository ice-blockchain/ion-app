// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/relays_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_provider.c.g.dart';

@riverpod
class Count extends _$Count {
  @override
  Future<int> build({
    required String pubkey,
    required EventCountResultType type,
    required List<RequestFilter> filters,
  }) async {
    final countEntity = ref.watch(
      ionConnectCacheProvider.select(
        cacheSelector<EventCountResultEntity>(
          EventCountResultEntity.cacheKeyBuilder(
            key: pubkey,
            type: type,
          ),
        ),
      ),
    );

    if (countEntity != null) {
      return countEntity.data.content as int;
    }

    return _fetchCount(pubkey, type, filters);
  }

  Future<int> _fetchCount(
    String pubkey,
    EventCountResultType type,
    List<RequestFilter> filters,
  ) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider).valueOrNull;
    if (currentPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final relay = await _getRandomUserRelay();
    final requestEvent = await _buildRequestEvent(relayUrl: relay.url, filters: filters);

    final subscriptionMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [EventCountResultEntity.kind, 7000],
          tags: {
            '#p': [currentPubkey],
          },
        ),
      );

    final subscription = relay.subscribe(subscriptionMessage);
    EventMessage? responseMessage;

    try {
      await ref.read(ionConnectNotifierProvider.notifier).sendEvent(
            requestEvent,
            actionSource: ActionSourceRelayUrl(relay.url),
            cache: false,
          );

      responseMessage = await subscription.messages
          .firstWhere((message) => message is EventMessage)
          .timeout(const Duration(seconds: 10)) as EventMessage;

      final eventCountResultEntity =
          EventCountResultEntity.fromEventMessage(responseMessage, key: pubkey);
      ref.read(ionConnectCacheProvider.notifier).cache(eventCountResultEntity);

      return eventCountResultEntity.data.content as int;
    } finally {
      relay.unsubscribe(subscription.id);
    }
  }

  Future<NostrRelay> _getRandomUserRelay() async {
    final userRelays = await ref.read(currentUserRelayProvider.future);
    if (userRelays == null) {
      throw UserRelaysNotFoundException();
    }

    final relayUrl = userRelays.data.list.random.url;
    return await ref.read(relayProvider(relayUrl).future);
  }

  Future<EventMessage> _buildRequestEvent({
    required String relayUrl,
    required List<RequestFilter> filters,
  }) async {
    final countRequest = EventCountRequestData(
      relays: [relayUrl],
      filters: filters,
    );

    return ref.read(ionConnectNotifierProvider.notifier).sign(countRequest);
  }
}
