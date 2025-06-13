// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/model/persistent_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/user_block/model/database/block_user_database.c.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_blocked_users_handler.c.g.dart';

class EncryptedBlockedUserEventHandler extends PersistentSubscriptionEncryptedEventMessageHandler {
  EncryptedBlockedUserEventHandler(this.blockEventDao, this.unblockEventDao);

  final BlockEventDao blockEventDao;
  final UnblockEventDao unblockEventDao;

  @override
  bool canHandle({required IonConnectGiftWrapEntity entity}) {
    return entity.data.kinds.containsKind([
      BlockedUserEntity.kind.toString(),
    ]);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    if (rumor.kind == BlockedUserEntity.kind) {
      await blockEventDao.add(rumor);
    } else if (rumor.kind == DeletionRequestEntity.kind) {
      final eventsToDelete = DeletionRequest.fromEventMessage(rumor).events;

      final eventToDeleteReferences =
          eventsToDelete.map((event) => (event as EventToDelete).eventReference).toList();
      if (eventToDeleteReferences.length == 1) {
        await unblockEventDao.add(eventToDeleteReferences.single);
      }
    }
  }
}

@riverpod
EncryptedBlockedUserEventHandler encryptedBlockedUserEventHandler(Ref ref) {
  return EncryptedBlockedUserEventHandler(
    ref.watch(blockEventDaoProvider),
    ref.watch(unblockEventDaoProvider),
  );
}
