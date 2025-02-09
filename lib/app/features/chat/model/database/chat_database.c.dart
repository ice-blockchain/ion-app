// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/related_subject.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_database.c.g.dart';
part 'dao/conversation_dao.c.dart';
part 'dao/conversation_event_message_dao.c.dart';
part 'dao/conversation_message_dao.c.dart';
part 'dao/conversation_message_status_dao.c.dart';
part 'tables/chat_message_table.dart';
part 'tables/conversation_table.dart';
part 'tables/event_message_table.dart';
part 'tables/message_status_table.dart';
part 'tables/reaction_table.dart';

@Riverpod(keepAlive: true)
ChatDatabase chatDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return ChatDatabase(pubkey);
}

@DriftDatabase(
  tables: [ConversationTable, EventMessageTable, ConversationMessageTable, MessageStatusTable],
)
class ChatDatabase extends _$ChatDatabase {
  ChatDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'chat_database_$pubkey');
  }
}
