// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.d.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/user_metadata/database/tables/user_metadata_table.d.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_database.m.g.dart';

@riverpod
UserMetadataDatabase userMetadataDatabase(Ref ref) {
  keepAliveWhenAuthenticated(ref);
  final masterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (masterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = UserMetadataDatabase(masterPubkey);

  onLogout(ref, database.close);

  return database;
}

@DriftDatabase(tables: [UserMetadataTable])
class UserMetadataDatabase extends _$UserMetadataDatabase {
  UserMetadataDatabase(this.masterPubkey) : super(_openConnection(masterPubkey));

  final String masterPubkey;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'user_metadata_database_$pubkey');
  }
}
