// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user_block/data/models/database/blocked_users_database.c.dart';
import 'package:ion/app/features/user_block/providers/blocked_users_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_event_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
BlockEventDao blockEventDao(Ref ref) => BlockEventDao(ref.watch(blockedUsersDatabaseProvider));
