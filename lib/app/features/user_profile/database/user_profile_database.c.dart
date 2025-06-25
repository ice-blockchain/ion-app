// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.d.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
<<<<<<<< HEAD:lib/app/features/user_profile/database/user_metadata_database.m.dart
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/user_metadata/database/tables/user_metadata_table.d.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_database.m.g.dart';
========
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user_profile/database/tables/user_badge_info_table.c.dart';
import 'package:ion/app/features/user_profile/database/tables/user_delegation_table.c.dart';
import 'package:ion/app/features/user_profile/database/tables/user_metadata_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_database.c.g.dart';
>>>>>>>> d3ecb7764 (feat: add delegation to profile db):lib/app/features/user_profile/database/user_profile_database.c.dart

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

@DriftDatabase(
  tables: [
    UserMetadataTable,
    UserDelegationTable,
    UserBadgeInfoTable,
  ],
)
class UserProfileDatabase extends _$UserProfileDatabase {
  UserProfileDatabase(this.masterPubkey) : super(_openConnection(masterPubkey));

  final String masterPubkey;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'user_profile_database_$pubkey');
  }
}
