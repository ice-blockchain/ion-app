// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:nip44/nip44.dart';
import 'package:nostr_dart/nostr_dart.dart';

class NostrSealService {
  /// https://github.com/nostr-protocol/nips/blob/master/59.md#2-seal-the-rumor
  static const int kind = 13;

  Future<EventMessage> encode(
    EventMessage rumor,
    EventSigner signer,
  ) async {
    final receiverPubkey = rumor.tags
        .firstWhereOrNull((tag) => tag[0] == RelatedPubkey.tagName)
        ?.let(RelatedPubkey.fromTag);

    if (receiverPubkey == null) {
      throw ReceiverPubkeyNotFoundException();
    }

    final encodedRumor = jsonEncode(rumor.toJson());

    final encryptedRumor = await Nip44.encryptMessage(
      encodedRumor,
      signer.privateKey,
      receiverPubkey.value,
    );

    final createdAt = randomDateBefore(const Duration(days: 2));

    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: kind,
      content: encryptedRumor,
    );
  }
}
