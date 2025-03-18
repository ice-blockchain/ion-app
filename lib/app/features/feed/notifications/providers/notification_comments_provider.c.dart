// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_comments_provider.c.g.dart';

@riverpod
Future<List<CommentIonNotification>> notificationComments(Ref ref) async {
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  return commentsRepository.getComments();
}
