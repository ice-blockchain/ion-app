// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/comments_repository.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/followers_repository.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/likes_repository.c.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_notifications_provider.c.g.dart';

@riverpod
Future<List<IonNotification>> allNotifications(Ref ref) async {
  final commentsRepository = ref.watch(commentsRepositoryProvider);
  final followersRepository = ref.watch(followersRepositoryProvider);
  final likesRepository = ref.watch(likesRepositoryProvider);
  final comments = await commentsRepository.getComments();
  final likes = await likesRepository.getAggregated();
  final followers = await followersRepository.getAggregated();
  return [...comments, ...likes, ...followers]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
}
