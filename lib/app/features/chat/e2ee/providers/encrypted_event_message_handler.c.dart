// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_deletion_event_message_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_direct_message_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_direct_message_reaction_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_repost_event_message_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/model/persistent_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_persistent_subscription.c.dart';
import 'package:ion/app/features/user_block/providers/encrypted_blocked_users_handler.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_event_message_handler.c.g.dart';

class EncryptedMessageEventHandler implements PersistentSubscriptionEventHandler {
  EncryptedMessageEventHandler({
    required this.handlers,
    required this.giftUnwrapService,
  });

  final List<PersistentSubscriptionEncryptedEventMessageHandler> handlers;
  final GiftUnwrapService giftUnwrapService;

  @override
  bool canHandle(EventMessage eventMessage) {
    return eventMessage.kind == IonConnectGiftWrapEntity.kind;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = IonConnectGiftWrapEntity.fromEventMessage(eventMessage);
    for (final handler in handlers) {
      if (handler.canHandle(entity: entity)) {
        final rumor = await giftUnwrapService.unwrap(eventMessage);
        unawaited(handler.handle(rumor));
        break;
      }
    }
  }
}

@riverpod
Future<EncryptedMessageEventHandler> encryptedMessageEventHandler(Ref ref) async {
  final handlers = [
    await ref.watch(encryptedDirectMessageEventHandlerProvider.future),
    ref.watch(encryptedDirectMessageReactionEventHandlerProvider),
    await ref.watch(encryptedDeletionRequestEventHandlerProvider.future),
    ref.watch(encryptedRepostEventMessageHandlerProvider),
    ref.watch(encryptedBlockedUserEventHandlerProvider),
  ];

  return EncryptedMessageEventHandler(
    handlers: handlers,
    giftUnwrapService: await ref.watch(giftUnwrapServiceProvider.future),
  );
}
