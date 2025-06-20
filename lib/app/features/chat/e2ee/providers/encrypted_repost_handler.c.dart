// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_repost_handler.c.g.dart';

class EncryptedRepostHandler extends GlobalSubscriptionEncryptedEventMessageHandler {
  EncryptedRepostHandler(this.eventMessageDao);

  final EventMessageDao eventMessageDao;

  @override
  bool canHandle({
    required IonConnectGiftWrapEntity entity,
  }) {
    return entity.data.kinds.containsDeep([
          GenericRepostEntity.kind.toString(),
          ArticleEntity.kind.toString(),
        ]) ||
        entity.data.kinds.containsDeep([
          GenericRepostEntity.kind.toString(),
          ModifiablePostEntity.kind.toString(),
        ]);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    await eventMessageDao.add(rumor);
  }
}

@riverpod
EncryptedRepostHandler encryptedRepostHandler(Ref ref) =>
    EncryptedRepostHandler(ref.watch(eventMessageDaoProvider));
