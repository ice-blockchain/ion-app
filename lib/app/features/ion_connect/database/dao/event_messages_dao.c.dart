// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/database/event_messages_database.c.dart';
import 'package:ion/app/features/ion_connect/database/tables/event_messages_table.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_messages_dao.c.g.dart';

@Riverpod(keepAlive: true)
EventMessagesDao eventMessagesDao(Ref ref) =>
    EventMessagesDao(db: ref.watch(eventMessagesDatabaseProvider));

@DriftAccessor(tables: [EventMessagesTable])
class EventMessagesDao extends DatabaseAccessor<EventMessagesDatabase>
    with _$EventMessagesDaoMixin {
  EventMessagesDao({required EventMessagesDatabase db}) : super(db);

  Future<void> insert(EventMessage eventMessage) async {
    await into(db.eventMessagesTable).insert(eventMessage, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertAll(List<EventMessage> eventMessages) {
    return batch((batch) {
      batch.insertAll(db.eventMessagesTable, eventMessages, mode: InsertMode.insertOrReplace);
    });
  }

  Future<Set<EventReference>> nonExistingReferences(Set<EventReference> eventReferences) async {
    final query = select(db.eventMessagesTable)
      ..where((event) => event.eventReference.isInValues(eventReferences));

    final existingReferences = (await query.map((message) => message.eventReference).get()).toSet();
    return eventReferences.difference(existingReferences);
  }
}
