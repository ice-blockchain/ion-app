// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/comments_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/followers_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/likes_dao.c.dart';
import 'package:ion/app/features/feed/notifications/providers/dao/comments_dao_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/dao/followers_dao_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/dao/likes_dao_provider.c.dart';
import 'package:ion/app/services/providers/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'unread_notifications_count_repository.c.g.dart';

@Riverpod(keepAlive: true)
UnreadNotificationsCountRepository? unreadNotificationsCountRepository(Ref ref) {
  final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (identityKeyName == null) {
    return null;
  }
  return UnreadNotificationsCountRepository(
    userPreferencesService:
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName)),
    commentsDao: ref.watch(commentsDaoProvider),
    likesDao: ref.watch(likesDaoProvider),
    followersDao: ref.watch(followersDaoProvider),
  );
}

class UnreadNotificationsCountRepository {
  UnreadNotificationsCountRepository({
    required UserPreferencesService userPreferencesService,
    required CommentsDao commentsDao,
    required LikesDao likesDao,
    required FollowersDao followersDao,
  })  : _userPreferencesService = userPreferencesService,
        _commentsDao = commentsDao,
        _likesDao = likesDao,
        _followersDao = followersDao;

  final UserPreferencesService _userPreferencesService;
  final CommentsDao _commentsDao;
  final LikesDao _likesDao;
  final FollowersDao _followersDao;

  Stream<int> watch() {
    final lastReadTime = _getOrInitLastReadTime();
    final likesStream = _likesDao.watchUnreadCount(after: lastReadTime);
    final commentsStream = _commentsDao.watchUnreadCount(after: lastReadTime);
    final followersStream = _followersDao.watchUnreadCount(after: lastReadTime);
    return commentsStream.combineLatestAll([likesStream, followersStream]).map((data) => data.sum);
  }

  void saveLastReadTime(DateTime time) {
    _userPreferencesService.setValue<int>(_storeKey, time.millisecondsSinceEpoch);
  }

  DateTime _getOrInitLastReadTime() {
    final readTimestamp = _userPreferencesService.getValue<int>(_storeKey);
    if (readTimestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(readTimestamp);
    } else {
      final now = DateTime.now();
      saveLastReadTime(now);
      return now;
    }
  }

  static const String _storeKey = 'unread_notifications_read_timestamp';
}
