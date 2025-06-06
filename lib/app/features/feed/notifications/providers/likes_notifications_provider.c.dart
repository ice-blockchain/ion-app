// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_notifications_provider.c.g.dart';

@riverpod
Future<List<LikesIonNotification>> likesNotifications(Ref ref) async {
  final likesRepository = ref.watch(likesRepositoryProvider);
  return likesRepository.getNotifications();
}
