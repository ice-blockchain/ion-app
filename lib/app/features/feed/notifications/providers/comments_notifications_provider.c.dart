// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/models/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/providers/repository/comments_repository.c.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_notifications_provider.c.g.dart';

@riverpod
Future<List<CommentIonNotification>> commentsNotifications(Ref ref) async {
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  return commentsRepository.getNotifications();
}
