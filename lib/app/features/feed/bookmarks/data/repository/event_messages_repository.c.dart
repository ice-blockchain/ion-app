// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/bookmarks/data/database/dao/event_messages_dao.c.dart';
import 'package:ion/app/features/feed/bookmarks/data/database/event_messages_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart' as ion;
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_messages_repository.c.g.dart';

@Riverpod(keepAlive: true)
EventMessagesRepository eventMessagesRepository(Ref ref) => EventMessagesRepository(
      eventMessagesDao: ref.watch(eventMessagesDaoProvider),
    );

class EventMessagesRepository {
  EventMessagesRepository({
    required EventMessagesDao eventMessagesDao,
  }) : _eventMessagesDao = eventMessagesDao;

  final EventMessagesDao _eventMessagesDao;

  Future<void> save(ion.EventMessage eventMessage, EventReference eventReference) async {
    final dbEventMessage = eventMessage.toDbModel(eventReference);
    return _eventMessagesDao.insert(dbEventMessage);
  }

  Future<void> saveAll(
    List<ion.EventMessage> eventMessages,
    List<EventReference> eventReferences,
  ) async {
    if (eventMessages.isEmpty) return;
    final dbEventMessages = eventMessages
        .mapIndexed(
          (index, eventMessage) => eventMessage.toDbModel(eventReferences[index]),
        )
        .toList();
    return _eventMessagesDao.insertAll(dbEventMessages);
  }

  Future<List<EventReference>> getNonSavedRefs(
    List<EventReference> eventReferences,
  ) async {
    final nonExistingReferences =
        await _eventMessagesDao.nonExistingReferences(eventReferences.toSet());
    return nonExistingReferences.toList();
  }
}

extension EventMessageX on ion.EventMessage {
  EventMessage toDbModel(EventReference eventReference) {
    return EventMessage(
      id: id,
      kind: kind,
      pubkey: pubkey,
      masterPubkey: masterPubkey,
      createdAt: createdAt,
      sig: sig,
      content: content,
      subscriptionId: subscriptionId,
      tags: tags,
      eventReference: eventReference,
    );
  }
}
