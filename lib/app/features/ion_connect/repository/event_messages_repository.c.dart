// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/database/dao/event_messages_dao.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
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

  Future<void> save(EventMessage eventMessage, EventReference eventReference) async {
    final dbEventMessage = eventMessage.toIonConnectDbModel(eventReference);
    return _eventMessagesDao.insert(dbEventMessage);
  }

  Future<void> saveAll(
    List<EventMessage> eventMessages,
    List<EventReference> eventReferences,
  ) async {
    if (eventMessages.isEmpty) return;
    final dbEventMessages = eventMessages
        .mapIndexed(
          (index, eventMessage) => eventMessage.toIonConnectDbModel(eventReferences[index]),
        )
        .toList();
    return _eventMessagesDao.insertAll(dbEventMessages);
  }

  Stream<EventMessage?> watch(
    EventReference eventReference,
  ) {
    final dbEventMessage = _eventMessagesDao.watch(eventReference);
    return dbEventMessage.map((e) => e?.toEventMessage());
  }

  Stream<List<EventMessage>> watchAll(
    List<EventReference> eventReferences,
  ) {
    final dbEventMessages = _eventMessagesDao.watchAll(eventReferences);
    return dbEventMessages.map((eventsList) => eventsList.map((e) => e.toEventMessage()).toList());
  }

  Future<List<EventReference>> getNonSavedRefs(
    List<EventReference> eventReferences,
  ) async {
    final nonExistingReferences =
        await _eventMessagesDao.nonExistingReferences(eventReferences.toSet());
    return nonExistingReferences.toList();
  }
}
