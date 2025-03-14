// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_type.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_replies_subscription_provider.c.g.dart';

@riverpod
Future<void> notificationRepliesSubscription(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  final eventParser = ref.watch(eventParserProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final since = await commentsRepository.lastCreatedAt(NotificationsType.reply);

  final requestFilter = RequestFilter(
    kinds: const [ModifiablePostEntity.kind],
    tags: {
      '#p': [currentPubkey],
    },
    search: SearchExtensions([
      TagMarkerSearchExtension(
        tagName: RelatedReplaceableEvent.tagName,
        marker: RelatedEventMarker.root.toShortString(),
      ),
    ]).toString(),
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
    commentsRepository.save(eventParser.parse(eventMessage));
  });

  ref.onDispose(subscription.cancel);
}
