// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_community_messages_provider.c.g.dart';

@Riverpod(keepAlive: true)
class FetchCommunityMessages extends _$FetchCommunityMessages {
  @override
  Stream<void> build() async* {
    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

    final joinedCommunities = await ref.watch(communityJoinRequestsProvider.future);

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final pubkey = eventSigner.publicKey;

    final communityIds = joinedCommunities.accepted.map((e) => e.data.uuid).toList();

    final requestFilter = RequestFilter(
      kinds: const [ModifiablePostEntity.kind],
      authors: [pubkey],
      tags: {
        '#h': communityIds,
      },
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
      requestMessage,
      subscriptionBuilder: (requestMessage, relay) {
        final subscription = relay.subscribe(requestMessage);
        ref.onDispose(() {
          try {
            relay.unsubscribe(subscription.id);
          } catch (error, stackTrace) {
            Logger.log('Failed to unsubscribe', error: error, stackTrace: stackTrace);
          }
        });
        return subscription.messages;
      },
    ).listen((event) {
      if (event.kind == ModifiablePostEntity.kind) {
        ref.watch(eventMessageTableDaoProvider).add(event);
      }
    });

    yield null;
  }
}
