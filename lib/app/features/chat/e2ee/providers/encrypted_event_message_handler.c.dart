// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_deletion_request_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_direct_message_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_direct_message_reaction_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_direct_message_status_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/encrypted_repost_handler.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_event_handler.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/user_block/providers/encrypted_blocked_users_handler.c.dart';
import 'package:ion/app/features/wallets/providers/fund_request_handler.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_asset_handler.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_event_message_handler.c.g.dart';

class EncryptedMessageEventHandler implements GlobalSubscriptionEventHandler {
  EncryptedMessageEventHandler({
    required this.handlers,
    required this.giftUnwrapService,
  });

  final List<GlobalSubscriptionEncryptedEventMessageHandler?> handlers;
  final GiftUnwrapService giftUnwrapService;

  @override
  bool canHandle(EventMessage eventMessage) {
    return eventMessage.kind == IonConnectGiftWrapEntity.kind;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = IonConnectGiftWrapEntity.fromEventMessage(eventMessage);
    for (final handler in handlers.nonNulls) {
      if (handler.canHandle(entity: entity)) {
        final rumor = await giftUnwrapService.unwrap(eventMessage);
        unawaited(handler.handle(rumor));
        break;
      }
    }
  }
}

@Riverpod(keepAlive: true)
Future<EncryptedMessageEventHandler> encryptedMessageEventHandler(Ref ref) async {
  final handlers = [
    ref.watch(encryptedDirectMessageStatusHandlerProvider),
    await ref.watch(encryptedDirectMessageHandlerProvider.future),
    ref.watch(encryptedDirectMessageReactionHandlerProvider),
    await ref.watch(encryptedDeletionRequestHandlerProvider.future),
    ref.watch(encryptedRepostHandlerProvider),
    ref.watch(encryptedBlockedUserHandlerProvider),
    await ref.watch(fundsRequestHandlerProvider.future),
    await ref.watch(walletAssetHandlerProvider.future),
  ];

  return EncryptedMessageEventHandler(
    handlers: handlers,
    giftUnwrapService: await ref.watch(giftUnwrapServiceProvider.future),
  );
}
