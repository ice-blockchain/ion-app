// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/followers_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_event_handler.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_notification_handler.c.g.dart';

class FollowNotificationHandler extends GlobalSubscriptionEventHandler {
  FollowNotificationHandler(
    this.followersRepository,
    this.currentMasterPubkey,
  );

  final FollowersRepository followersRepository;
  final String currentMasterPubkey;

  @override
  bool canHandle(EventMessage eventMessage) {
    return eventMessage.kind == FollowListEntity.kind;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = FollowListEntity.fromEventMessage(eventMessage);
    final isCurrentUserLastAdded = entity.data.list.lastOrNull?.pubkey == currentMasterPubkey;

    if (isCurrentUserLastAdded) {
      await followersRepository.save(entity);
    }
  }
}

@riverpod
FollowNotificationHandler followNotificationHandler(Ref ref) {
  final followersRepository = ref.watch(followersRepositoryProvider);
  final currentMasterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return FollowNotificationHandler(followersRepository, currentMasterPubkey);
}
