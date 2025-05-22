// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/event_message.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_database.c.g.dart';
part 'dao/block_event_dao.c.dart';
part 'tables/block_event_table.dart';

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

@DriftDatabase(tables: [BlockEventTable])
class BlockedUsersDatabase extends _$BlockedUsersDatabase {
  BlockedUsersDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'blocked_users_database_$pubkey');
  }
}
