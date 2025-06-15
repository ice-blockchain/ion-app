// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_event_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repost_notification_handler.c.g.dart';

class RepostNotificationHandler extends GlobalSubscriptionEventHandler {
  RepostNotificationHandler(this.commentsRepository, this.currentPubkey);
  final CommentsRepository commentsRepository;
  final String currentPubkey;

  @override
  bool canHandle(EventMessage eventMessage) {
    if (eventMessage.kind == GenericRepostEntity.kind) {
      final entity = GenericRepostEntity.fromEventMessage(eventMessage);
      if (entity.data.kind == ModifiablePostEntity.kind || entity.data.kind == ArticleEntity.kind) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = GenericRepostEntity.fromEventMessage(eventMessage);
    final isOwnRepost = entity.masterPubkey == currentPubkey;
    if (!isOwnRepost) {
      await commentsRepository.save(entity);
    }
  }
}

@riverpod
RepostNotificationHandler repostNotificationHandler(Ref ref) {
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return RepostNotificationHandler(commentsRepository, currentPubkey);
}
