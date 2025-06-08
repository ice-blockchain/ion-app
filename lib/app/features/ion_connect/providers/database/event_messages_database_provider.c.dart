// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/database/event_messages_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_messages_database_provider.c.g.dart';

@Riverpod(keepAlive: true)
EventMessagesDatabase eventMessagesDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = EventMessagesDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}
