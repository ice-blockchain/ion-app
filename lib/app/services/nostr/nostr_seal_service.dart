// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/utils/date.dart';
import 'package:nip44/nip44.dart';
import 'package:nostr_dart/nostr_dart.dart';

abstract class NostrSealService {
  Future<EventMessage> createSeal(
    EventMessage rumor,
    EventSigner signer,
    String recipientPublicKey,
  );

  Future<EventMessage> decodeSeal(
    EventMessage seal,
    EventSigner signer,
  );
}

class NostrSealServiceImpl implements NostrSealService {
  static const int sealKind = 13;

  @override
  Future<EventMessage> createSeal(
    EventMessage rumor,
    EventSigner signer,
    String recipientPublicKey,
  ) async {
    final encodedRumor = jsonEncode(rumor.toJson());

    final encryptedRumor = await Nip44.encryptMessage(
      encodedRumor,
      signer.privateKey,
      recipientPublicKey,
    );

    final createdAt = randomDateBefore(
      const Duration(days: 2),
    );

    return EventMessage.fromData(
      signer: signer,
      kind: sealKind,
      createdAt: createdAt,
      content: encryptedRumor,
    );
  }

  @override
  Future<EventMessage> decodeSeal(
    EventMessage seal,
    EventSigner signer,
  ) async {
    final decryptedContent = await Nip44.decryptMessage(
      seal.content,
      signer.privateKey,
      seal.pubkey,
    );

    return EventMessage.fromJson(jsonDecode(decryptedContent) as List);
  }
}
