// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/persistent_subscription_event_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quote_notification_handler.c.g.dart';

class QuoteNotificationHandler extends PersistentSubscriptionEventHandler {
  QuoteNotificationHandler(this.commentsRepository, this.currentPubkey);

  final CommentsRepository commentsRepository;
  final String currentPubkey;

  @override
  bool canHandle(EventMessage eventMessage) {
    final isQuote = eventMessage.tags.any((tag) => tag.first == 'Q' && tag.last == currentPubkey);
    return eventMessage.kind == ModifiablePostEntity.kind && isQuote;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final isOwnQuote = eventMessage.masterPubkey == currentPubkey;
    if (!isOwnQuote) {
      final entity = ModifiablePostEntity.fromEventMessage(eventMessage);
      await commentsRepository.save(entity);
    }
  }
}

@riverpod
QuoteNotificationHandler quoteNotificationHandler(Ref ref) {
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return QuoteNotificationHandler(commentsRepository, currentPubkey);
}
