// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/followers_dao.c.dart';
import 'package:ion/app/features/feed/notifications/providers/database/notifications_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
FollowersDao followersDao(Ref ref) => FollowersDao(db: ref.watch(notificationsDatabaseProvider));
