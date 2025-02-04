// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
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
  Future<void> build() async {
    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final pubkey = eventSigner.publicKey;

    final requestFilter = RequestFilter(
      kinds: const [ModifiablePostEntity.kind],
      authors: [pubkey],
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final messagesStream = ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
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
    );

    await for (final message in messagesStream) {
      await ref.watch(eventMessageTableDaoProvider).add(message);
    }
  }
}
