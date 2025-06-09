// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user_block/model/database/block_user_database.c.dart';

extension BlockEventExtensions on EventMessage {
  BlockEventDbModel toBlockEventDbModel(EventReference eventReference) {
    return BlockEventDbModel(
      id: id,
      kind: kind,
      tags: tags,
      pubkey: pubkey,
      content: content,
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
