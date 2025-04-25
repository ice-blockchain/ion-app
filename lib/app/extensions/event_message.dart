// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
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
}
