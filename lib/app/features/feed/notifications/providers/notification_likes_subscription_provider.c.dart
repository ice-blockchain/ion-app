// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_likes_subscription_provider.c.g.dart';

@riverpod
Future<void> notificationLikesSubscription(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final likesRepository = ref.watch(likesRepositoryProvider);
  final eventParser = ref.watch(eventParserProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final since = await likesRepository.lastCreatedAt();

  final requestFilter = RequestFilter(
    kinds: const [ReactionEntity.kind],
    tags: {
      '#p': [currentPubkey],
    },
    since: since?.subtract(const Duration(seconds: 2)),
  );
  final requestMessage = RequestMessage()..addFilter(requestFilter);

  final events = ref.watch(ionConnectNotifierProvider.notifier).requestEvents(
    requestMessage,
    subscriptionBuilder: (requestMessage, relay) {
      final subscription = relay.subscribe(requestMessage);
      ref.onDispose(() => relay.unsubscribe(subscription.id));
      return subscription.messages;
    },
  );

  final subscription = events.listen((eventMessage) {
    if (eventMessage.masterPubkey != currentPubkey) {
      likesRepository.save(eventParser.parse(eventMessage));
    }
  });

  ref.onDispose(subscription.cancel);
}
