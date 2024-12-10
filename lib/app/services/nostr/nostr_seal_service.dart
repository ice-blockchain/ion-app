// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/services/nostr/ed25519_key_store.dart';
import 'package:ion/app/utils/date.dart';
import 'package:nip44/nip44.dart';
import 'package:nostr_dart/nostr_dart.dart';

class NostrSealService {
  /// https://github.com/nostr-protocol/nips/blob/master/59.md#2-seal-the-rumor
  static const int kind = 13;

  Future<EventMessage> encode(EventMessage inputEvent) async {
    final keyStore = await Ed25519KeyStore.generate();

    final rumor = jsonEncode(inputEvent.toJson());

    final seal = await Nip44.encryptMessage(
      rumor,
      inputEvent.pubkey,
      keyStore.privateKey,
    );

    final createdAt = randomDateBefore(const Duration(days: 2));

    final id = EventMessage.calculateEventId(
      publicKey: inputEvent.pubkey,
      createdAt: createdAt,
      kind: kind,
      tags: [],
      content: seal,
    );

    final event = EventMessage(
      id: id,
      pubkey: inputEvent.pubkey,
      createdAt: createdAt,
      kind: kind,
      content: seal,
      tags: const [],
      sig: keyStore.privateKey,
    );

    return event;
  }
}
