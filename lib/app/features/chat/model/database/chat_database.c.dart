// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.steps.dart';
import 'package:ion/app/features/chat/model/group_subject.c.dart';
import 'package:ion/app/features/chat/model/message_reaction_group.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_database.c.g.dart';
part 'dao/conversation_dao.c.dart';
part 'dao/conversation_event_message_dao.c.dart';
part 'dao/conversation_message_dao.c.dart';
part 'dao/conversation_message_data_dao.c.dart';
part 'dao/conversation_message_reaction_dao.c.dart';
part 'dao/event_message_dao.c.dart';
part 'dao/message_media_dao.c.dart';
part 'tables/chat_message_table.dart';
part 'tables/conversation_table.dart';
part 'tables/event_message_table.dart';
part 'tables/message_media_table.dart';
part 'tables/message_status_table.dart';
part 'tables/reaction_table.dart';

@Riverpod(keepAlive: true)
ChatDatabase chatDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = ChatDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}

@DriftDatabase(
  tables: [
    ConversationTable,
    EventMessageTable,
    ConversationMessageTable,
    MessageStatusTable,
    ReactionTable,
    MessageMediaTable,
  ],
)
class ChatDatabase extends _$ChatDatabase {
  ChatDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'conversation_database_$pubkey');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) => m.createAll(),
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await Future.wait(
            [
              m.alterTable(
                TableMigration(
                  schema.conversationTable,
                  columnTransformer: {
                    schema.conversationTable.joinedAt:
                        schema.conversationTable.joinedAt.cast<int>(),
                  },
                ),
              ),
              m.alterTable(
                TableMigration(
                  schema.eventMessageTable,
                  columnTransformer: {
                    schema.eventMessageTable.createdAt:
                        schema.eventMessageTable.createdAt.cast<int>(),
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
