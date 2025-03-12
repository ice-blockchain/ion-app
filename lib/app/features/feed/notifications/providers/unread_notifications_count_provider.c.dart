import 'package:ion/app/features/feed/notifications/data/repository/unread_count_repository.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unread_notifications_count_provider.c.g.dart';

@riverpod
class UnreadNotificationsCount extends _$UnreadNotificationsCount {
  @override
  Stream<int> build() async* {
    final unreadCountRepository = ref.watch(unreadCountRepositoryProvider);
    if (unreadCountRepository != null) {
      yield* unreadCountRepository.watch();
    }
  }

  void readAll() {}
}
