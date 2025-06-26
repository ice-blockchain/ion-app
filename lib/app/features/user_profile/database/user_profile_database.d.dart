// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.d.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/user_profile/database/tables/user_badge_info_table.d.dart';
import 'package:ion/app/features/user_profile/database/tables/user_delegation_table.d.dart';
import 'package:ion/app/features/user_profile/database/tables/user_metadata_table.d.dart';

part 'user_profile_database.d.g.dart';

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
