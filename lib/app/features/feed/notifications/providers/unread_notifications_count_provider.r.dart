// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/notifications/data/repository/unread_notifications_count_repository.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unread_notifications_count_provider.r.g.dart';

@riverpod
class UnreadNotificationsCount extends _$UnreadNotificationsCount {
  @override
  Stream<int> build() async* {
    final unreadCountRepository = ref.watch(unreadNotificationsCountRepositoryProvider);
    if (unreadCountRepository != null) {
      yield* unreadCountRepository.watch();
    }
  }

  void readAll() {
    ref.read(unreadNotificationsCountRepositoryProvider)?.saveLastReadTime(DateTime.now());
    ref.invalidateSelf();
  }
}
