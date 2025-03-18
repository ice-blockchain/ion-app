// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/followers_repository.c.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_followers_provider.c.g.dart';

@riverpod
Future<List<FollowersIonNotification>> notificationFollowers(Ref ref) async {
  final followersRepository = ref.watch(followersRepositoryProvider);
  return followersRepository.getAggregated();
}
