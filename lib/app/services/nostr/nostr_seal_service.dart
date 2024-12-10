// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/utils/date.dart';
import 'package:nip44/nip44.dart';
import 'package:nostr_dart/nostr_dart.dart';

class NostrSealService {
  /// https://github.com/nostr-protocol/nips/blob/master/59.md#2-seal-the-rumor
  static const int kind = 13;

  Future<EventMessage> encode(EventMessage rumor, EventSigner signer) async {
    final encodedRumor = jsonEncode(rumor.toJson());

    final encryptedRumor = await Nip44.encryptMessage(
      encodedRumor,
      signer.privateKey,
      signer.publicKey,
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
