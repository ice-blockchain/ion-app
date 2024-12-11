// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/features/feed/data/models/entities/related_pubkey.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:nip44/nip44.dart';
import 'package:nostr_dart/nostr_dart.dart';

abstract class NostrGiftWrapService {
  Future<EventMessage> createWrap(
    EventMessage event,
    String pubkey,
    EventSigner signer,
  );

  Future<EventMessage> decodeWrap(
    EventMessage wrap,
    String pubkey,
    EventSigner signer,
  );
}

class NostrGiftWrapServiceImpl implements NostrGiftWrapService {
  static const int wrapKind = 1059;

  @override
  Future<EventMessage> createWrap(
    EventMessage event,
    String pubkey,
    EventSigner signer,
  ) async {
    final encryptedEvent = await Nip44.encryptMessage(
      jsonEncode(event.toJson()),
      signer.privateKey,
      pubkey,
    );

    final createdAt = randomDateBefore(
      const Duration(days: 2),
    );

    return EventMessage.fromData(
      signer: signer,
      kind: wrapKind,
      createdAt: createdAt,
      content: encryptedEvent,
      tags: [
        [RelatedPubkey.tagName, pubkey],
        ['k', '14'],
      ],
    );
  }

  @override
  Future<EventMessage> decodeWrap(
    EventMessage wrap,
    String pubkey,
    EventSigner signer,
  ) async {
    final decryptedContent = await Nip44.decryptMessage(
      wrap.content,
      signer.privateKey,
      pubkey,
    );

    return EventMessage.fromJson(jsonDecode(decryptedContent) as List);
  }
}
