// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart' as chat_db;
import 'package:ion/app/features/ion_connect/database/event_messages_database.c.dart'
    as event_messages_db;
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';

extension KeysExtensions on EventMessage {
  String get masterPubkey {
    final masterPubkey = tags.firstWhereOrNull((tags) => tags[0] == 'b')?.elementAtOrNull(1);

    if (masterPubkey == null) {
      throw EventMasterPubkeyNotFoundException(eventId: id);
    }

    return masterPubkey;
  }

  List<String> get participantsMasterPubkeys {
    final allTags = groupBy(tags, (tag) => tag[0]);
    final masterPubkeys = allTags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList();

    return masterPubkeys?.map((e) => e.value).toList() ?? [];
  }

  String? get sharedId =>
      tags.firstWhereOrNull((tag) => tag.first == ReplaceableEventIdentifier.tagName)?.last;

  event_messages_db.EventMessageDbModel toIonConnectDbModel(EventReference eventReference) {
    return event_messages_db.EventMessageDbModel(
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

  chat_db.EventMessageDbModel toChatDbModel(EventReference eventReference) {
    return chat_db.EventMessageDbModel(
      id: id,
      kind: kind,
      pubkey: pubkey,
      masterPubkey: masterPubkey,
      createdAt: createdAt,
      content: content,
      tags: tags,
      eventReference: eventReference,
    );
  }
}

extension IonConnectEventMessageDbModelExtensions on event_messages_db.EventMessageDbModel {
  EventMessage toEventMessage() {
    return EventMessage(
      id: id,
      kind: kind,
      pubkey: pubkey,
      createdAt: createdAt,
      sig: sig,
      content: content,
      subscriptionId: subscriptionId,
      tags: tags,
    );
  }
}

extension ChatEventMessageDbModelExtensions on chat_db.EventMessageDbModel {
  EventMessage toEventMessage() {
    return EventMessage(
      id: id,
      kind: kind,
      pubkey: pubkey,
      createdAt: createdAt,
      sig: sig,
      content: content,
      subscriptionId: subscriptionId,
      tags: tags,
    );
  }
}
