// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/user_profile/database/user_profile_database.d.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_database_provider.r.g.dart';

@riverpod
UserProfileDatabase userProfileDatabase(Ref ref) {
  keepAliveWhenAuthenticated(ref);
  final masterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (masterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = UserProfileDatabase(masterPubkey);

  onLogout(ref, database.close);

  return database;
}
