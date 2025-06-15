// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_event_message_handler.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notifications/follow_notification_handler.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notifications/like_notification_handler.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notifications/quote_notification_handler.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notifications/reply_notification_handler.c.dart';
import 'package:ion/app/features/feed/notifications/providers/notifications/repost_notification_handler.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_event_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_subscription_event_dispatcher_provider.c.g.dart';

class GlobalSubscriptionEventDispatcher {
  GlobalSubscriptionEventDispatcher(this.ref, this._handlers);

  final Ref ref;
  final List<GlobalSubscriptionEventHandler> _handlers;

  Future<void> dispatch(EventMessage eventMessage) async {
    for (final handler in _handlers) {
      if (handler.canHandle(eventMessage)) {
        unawaited(handler.handle(eventMessage));
        break;
      }
    }
  }
}

@riverpod
Future<GlobalSubscriptionEventDispatcher> globalSubscriptionEventDispatcherNotifier(
  Ref ref,
) async {
  return GlobalSubscriptionEventDispatcher(ref, [
    await ref.watch(encryptedMessageEventHandlerProvider.future),
    ref.watch(followNotificationHandlerProvider),
    ref.watch(likeNotificationHandlerProvider),
    ref.watch(quoteNotificationHandlerProvider),
    ref.watch(replyNotificationHandlerProvider),
    ref.watch(repostNotificationHandlerProvider),
  ]);
}
