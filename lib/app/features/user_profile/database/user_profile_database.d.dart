// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.d.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/user_profile/database/tables/user_badge_info_table.d.dart';
import 'package:ion/app/features/user_profile/database/tables/user_delegation_table.d.dart';
import 'package:ion/app/features/user_profile/database/tables/user_metadata_table.d.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';

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

  /// Opens a connection to the database with the given pubkey
  /// For iOS, it uses the shared app group container if available
  /// For other platforms, it uses the default location
  static QueryExecutor _openConnection(String pubkey) {
    const appGroupId = String.fromEnvironment('FOUNDATION_APP_GROUP');
    final databaseName = 'user_profile_database_$pubkey';

    if (Platform.isIOS && appGroupId.isNotEmpty) {
      return driftDatabase(
        name: databaseName,
        native: DriftNativeOptions(
          databasePath: () async {
            final sharedPath =
                await PathProviderFoundation().getContainerPath(appGroupIdentifier: appGroupId);

            if (sharedPath == null || sharedPath.isEmpty) {
              return (await getApplicationDocumentsDirectory()).path;
            }

            final dbFile = join(sharedPath, '$databaseName.sqlite');

            final dbDir = Directory(dirname(dbFile));
            if (!dbDir.existsSync()) {
              dbDir.createSync(recursive: true);
            }

            return dbFile;
          },
          shareAcrossIsolates: true,
        ),
      );
    } else {
      return driftDatabase(
        name: databaseName,
        native: const DriftNativeOptions(
          shareAcrossIsolates: true,
        ),
      );
    }
  }
}
