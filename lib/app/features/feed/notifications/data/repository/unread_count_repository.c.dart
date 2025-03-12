// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/comments_dao.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unread_count_repository.c.g.dart';

@Riverpod(keepAlive: true)
UnreadCountRepository? unreadCountRepository(Ref ref) {
  final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (identityKeyName == null) {
    return null;
  }
  return UnreadCountRepository(
    userPreferencesService:
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName)),
    commentsDao: ref.watch(commentsDaoProvider),
  );
}

class UnreadCountRepository {
  UnreadCountRepository({
    required UserPreferencesService userPreferencesService,
    required CommentsDao commentsDao,
  })  : _userPreferencesService = userPreferencesService,
        _commentsDao = commentsDao;

  final UserPreferencesService _userPreferencesService;
  final CommentsDao _commentsDao;

  Stream<int> watch() {
    final readTimestamp = _userPreferencesService.getValue<int>(_storeKey);
    return _commentsDao.watchUnreadCount();
  }

  static const String _storeKey = 'unread_notifications_read_timestamp';
}
