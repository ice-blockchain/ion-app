// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user_block/model/database/blocked_users_database.c.dart';

extension BlockEventExtensions on EventMessage {
  BlockEventDbModel toBlockEventDbModel(EventReference eventReference) {
    final sharedId = tags.firstWhereOrNull((tag) => tag.first == 'd')?.last;

    if (sharedId == null) {
      throw ShareableIdentifierDecodeException(id);
    }

    return BlockEventDbModel(
      id: id,
      kind: kind,
      tags: tags,
      pubkey: pubkey,
      content: content,
      sharedId: sharedId,
      createdAt: createdAt,
      masterPubkey: masterPubkey,
      eventReference: eventReference,
    );
  }
}

extension BlockEventDbModelExtensions on BlockEventDbModel {
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
