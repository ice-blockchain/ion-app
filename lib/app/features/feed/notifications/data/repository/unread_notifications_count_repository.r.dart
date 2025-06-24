// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/comments_dao.m.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/followers_dao.m.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/likes_dao.m.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';

part 'unread_notifications_count_repository.r.g.dart';

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
    contentDao: ref.watch(contentDaoProvider),
    likesDao: ref.watch(likesDaoProvider),
    followersDao: ref.watch(followersDaoProvider),
  );
}

class UnreadNotificationsCountRepository {
  UnreadNotificationsCountRepository({
    required UserPreferencesService userPreferencesService,
    required CommentsDao commentsDao,
    required ContentDao contentDao,
    required LikesDao likesDao,
    required FollowersDao followersDao,
  })  : _userPreferencesService = userPreferencesService,
        _commentsDao = commentsDao,
        _contentDao = contentDao,
        _likesDao = likesDao,
        _followersDao = followersDao;

  final UserPreferencesService _userPreferencesService;
  final CommentsDao _commentsDao;
  final ContentDao _contentDao;
  final LikesDao _likesDao;
  final FollowersDao _followersDao;

  Stream<int> watch() {
    final lastReadTime = _getOrInitLastReadTime();
    final likesStream = _likesDao.watchUnreadCount(after: lastReadTime);
    final commentsStream = _commentsDao.watchUnreadCount(after: lastReadTime);
    final contentStream = _contentDao.watchUnreadCount(after: lastReadTime);
    final followersStream = _followersDao.watchUnreadCount(after: lastReadTime);
    return commentsStream
        .combineLatestAll([likesStream, contentStream, followersStream]).map((data) => data.sum);
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
