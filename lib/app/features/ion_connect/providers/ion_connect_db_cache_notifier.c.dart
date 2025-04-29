// SPDX-License-Identifier: ice License 1.0

import 'package:async/async.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_parser.c.dart';
import 'package:ion/app/features/ion_connect/repository/event_messages_repository.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_db_cache_notifier.c.g.dart';

@riverpod
class IonConnectDbCache extends _$IonConnectDbCache {
  @override
  FutureOr<void> build() async {}

  Stream<List<IonConnectEntity>> watch(List<EventReference> eventReferences) {
    final eventMessagesStream =
        ref.watch(eventMessagesRepositoryProvider).watchAll(eventReferences);
    final parser = ref.read(eventParserProvider);
    return eventMessagesStream.map((eventMessages) => eventMessages.map(parser.parse).toList());
  }

  Future<List<IonConnectEntity>> get(List<EventReference> eventReferences) async {
    final eventMessages =
        await ref.read(eventMessagesRepositoryProvider).watchAll(eventReferences).firstOrNull;
    final parser = ref.read(eventParserProvider);
    return eventMessages?.map(parser.parse).toList() ?? [];
  }

  Future<void> save(EntityEventSerializable eventSerializable) async {
    final eventMessage = await eventSerializable.toEntityEventMessage();
    final eventReference = eventSerializable.toEventReference();
    await ref.read(eventMessagesRepositoryProvider).save(eventMessage, eventReference);
  }

  Future<void> saveAll(List<EntityEventSerializable> eventSerializables) async {
    if (eventSerializables.isEmpty) return;
    final eventMessages = await Future.wait(
      eventSerializables.map(
        (eventSerializable) {
          final eventMessage = eventSerializable.toEntityEventMessage();
          if (eventMessage is Future) {
            return eventMessage as Future<EventMessage>;
          } else {
            return Future<EventMessage>.value(eventMessage);
          }
        },
      ),
    );
    final eventReferences = eventSerializables
        .map((eventSerializable) => eventSerializable.toEventReference())
        .toList();
    await ref.read(eventMessagesRepositoryProvider).saveAll(eventMessages, eventReferences);
  }
}
