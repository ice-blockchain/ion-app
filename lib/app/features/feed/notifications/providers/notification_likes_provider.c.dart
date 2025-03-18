// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_connect_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_likes_provider.c.g.dart';

@riverpod
Future<List<LikesIonNotification>> notificationLikes(Ref ref) async {
  final likesRepository = ref.watch(likesRepositoryProvider);
  return likesRepository.getAggregated();
}
