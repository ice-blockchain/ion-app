// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/likes_dao.c.dart';
import 'package:ion/app/features/feed/notifications/providers/database/notifications_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
LikesDao likesDao(Ref ref) => LikesDao(db: ref.watch(notificationsDatabaseProvider));
