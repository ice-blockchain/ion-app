// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_error_entity.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_request_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_provider.c.g.dart';

@riverpod
class Count extends _$Count {
  // TODO: Generics available in riverpod, but this requires using the 3.0 dev release,
  // so we need to wait for the stable release to use it.
  @override
  Future<dynamic> build({
    required String key,
    required NostrRelay relay,
    required EventCountResultType type,
    required List<RequestFilter> filters,
    Duration? cacheExpirationDuration,
    bool cache = true,
  }) async {
    if (cache) {
      final countEntity = ref.watch(
        ionConnectCacheProvider.select(
          cacheSelector<EventCountResultEntity>(
            EventCountResultEntity.cacheKeyBuilder(
              key: key,
              type: type,
            ),
            expirationDuration: cacheExpirationDuration,
          ),
        ),
      );

      if (countEntity != null) {
        return countEntity.data.content as int;
      }
    }

    return _fetchCount(key: key, relay: relay, filters: filters);
  }

  Future<dynamic> _fetchCount({
    required String key,
    required NostrRelay relay,
    required List<RequestFilter> filters,
  }) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final requestEvent = await _buildRequestEvent(relayUrl: relay.url, filters: filters);

    final subscriptionMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [EventCountResultEntity.kind, EventCountErrorEntity.kind],
          tags: {
            '#p': [currentPubkey],
          },
        ),
      );

    final subscription = relay.subscribe(subscriptionMessage);

    try {
      await ref.read(ionConnectNotifierProvider.notifier).sendEvent(
            requestEvent,
            actionSource: ActionSourceRelayUrl(relay.url),
            cache: false,
          );

      final responseEntity = await subscription.messages
          .where((message) => message is EventMessage)
          .cast<EventMessage>()
          .map<dynamic>((message) {
            return switch (message.kind) {
              EventCountResultEntity.kind =>
                EventCountResultEntity.fromEventMessage(message, key: key),
              EventCountErrorEntity.kind => EventCountErrorEntity.fromEventMessage(message),
              _ => throw IncorrectEventKindException(message, kind: message.kind),
            };
          })
          .firstWhere(
            (entity) => switch (entity) {
              EventCountResultEntity() => entity.data.requestEventId == requestEvent.id,
              EventCountErrorEntity() => entity.data.eventReference.toString() == requestEvent.id,
              _ => false,
            },
          )
          .timeout(const Duration(seconds: 10));

      if (responseEntity is EventCountErrorEntity) {
        final errorContent = responseEntity.data.content;
        if (errorContent is String) {
          throw EventCountException(errorContent);
        } else {
          throw EventCountException('Unexpected error content type');
        }
      } else if (responseEntity is EventCountResultEntity) {
        ref.read(ionConnectCacheProvider.notifier).cache(responseEntity);
        return responseEntity.data.content;
      }
    } finally {
      relay.unsubscribe(subscription.id);
    }
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
