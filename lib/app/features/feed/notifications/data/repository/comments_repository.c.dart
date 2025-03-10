// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/comments_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_repository.c.g.dart';

@Riverpod(keepAlive: true)
CommentsRepository commentsRepository(Ref ref) => CommentsRepository(
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

  Future<void> save(IonConnectEntity entity) {
    final type = switch (entity) {
      ModifiablePostEntity() => CommentType.reply,
      _ => throw UnimplementedError(), //TODO:
    };
    return _commentsDao.insert(entity, type: type);
  }
}
