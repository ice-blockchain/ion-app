// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/comments_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_repository.c.g.dart';

@Riverpod(keepAlive: true)
CommentsRepository commentsRepository(
  Ref ref,
  ProviderListenable<CommentsDao> commentsDaoProvider,
) =>
    CommentsRepository(
      commentsDao: ref.watch(commentsDaoProvider),
    );

class CommentsRepository {
  CommentsRepository({
    required CommentsDao commentsDao,
  }) : _commentsDao = commentsDao;

  final CommentsDao _commentsDao;

  Future<List<Comment>> getAll() {
    return _commentsDao.getAll();
  }
}
