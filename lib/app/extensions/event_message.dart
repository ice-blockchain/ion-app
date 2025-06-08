// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/master_pubkey_tag.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart' as chat_db;
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/database/event_messages_database.c.dart'
    as event_messages_db;
import 'package:ion/app/features/ion_connect/ion_connect.dart';

extension KeysExtensions on EventMessage {
  String get masterPubkey {
    final masterPubkey =
        tags.firstWhereOrNull((tags) => tags[0] == MasterPubkeyTag.tagName)?.elementAtOrNull(1);

    if (masterPubkey == null) {
      throw EventMasterPubkeyNotFoundException(eventId: id);
    }

    return masterPubkey;
  }

  event_messages_db.EventMessageDbModel toIonConnectDbModel(EventReference eventReference) {
    return event_messages_db.EventMessageDbModel(
      id: id,
      kind: kind,
      pubkey: pubkey,
      masterPubkey: masterPubkey,
      createdAt: createdAt,
      sig: sig,
      content: content,
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
      content: content,
      tags: tags,
      sig: null,
    );
  }
}
