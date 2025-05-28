// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/user_block/model/database/blocked_users_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_database_provider.c.g.dart';

@Riverpod(keepAlive: true)
BlockedUsersDatabase blockedUsersDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = BlockedUsersDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}
