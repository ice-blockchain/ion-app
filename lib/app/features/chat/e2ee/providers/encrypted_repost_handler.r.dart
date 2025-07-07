// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.f.dart';
import 'package:ion/app/features/user_profile/providers/user_profile_sync_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_repost_handler.r.g.dart';

class EncryptedRepostHandler extends GlobalSubscriptionEncryptedEventMessageHandler {
  EncryptedRepostHandler(this.eventMessageDao, this.userProfileSync, this.currentUserMasterPubkey);

  final EventMessageDao eventMessageDao;
  final UserProfileSync userProfileSync;
  final String currentUserMasterPubkey;

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
    _syncUserProfile(rumor: rumor);
    await eventMessageDao.add(rumor);
  }

  void _syncUserProfile({required EventMessage rumor}) {
    final masterPubKeys = <String>{};

    if (rumor.masterPubkey != currentUserMasterPubkey) {
      masterPubKeys.add(rumor.masterPubkey);
    }

    final repliedEventMasterPubkey = _getRepliedEventMasterPubkey(rumor);
    if (repliedEventMasterPubkey != null && repliedEventMasterPubkey != currentUserMasterPubkey) {
      masterPubKeys.add(repliedEventMasterPubkey);
    }

    unawaited(userProfileSync.syncUserProfile(masterPubkeys: masterPubKeys));
  }

  String? _getRepliedEventMasterPubkey(EventMessage rumor) {
    final tags = groupBy(rumor.tags, (tag) => tag[0]);
    final eventReference = tags[ReplaceableEventReference.tagName]?.firstOrNull;

    if (eventReference != null) {
      final referenceMasterPubkey = ReplaceableEventReference.fromTag(eventReference).masterPubkey;
      return referenceMasterPubkey;
    }
    return null;
  }
}

@riverpod
EncryptedRepostHandler? encryptedRepostHandler(Ref ref) {
  final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentUserMasterPubkey == null) {
    return null;
  }

  return EncryptedRepostHandler(
    ref.watch(eventMessageDaoProvider),
    ref.watch(userProfileSyncProvider.notifier),
    currentUserMasterPubkey,
  );
}
