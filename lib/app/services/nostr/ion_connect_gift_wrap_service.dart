// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:ion/app/features/nostr/model/related_pubkey.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:nip44/nip44.dart';
import 'package:nostr_dart/nostr_dart.dart';

abstract class IonConnectGiftWrapService {
  Future<EventMessage> createWrap(
    EventMessage event,
    String receiverPubkey,
    EventSigner signer,
    int contentKind, {
    List<String>? expirationTag,
  });

  Future<EventMessage> decodeWrap(
    EventMessage wrap,
    String pubkey,
    EventSigner signer,
  );
}

class IonConnectGiftWrapServiceImpl implements IonConnectGiftWrapService {
  static const int wrapKind = 1059;

  @override
  Future<EventMessage> createWrap(
    EventMessage event,
    String receiverPubkey,
    EventSigner signer,
    int contentKind, {
    List<String>? expirationTag,
  }) async {
    final encryptedEvent = await Nip44.encryptMessage(
      jsonEncode(event.toJson().last),
      signer.privateKey,
      receiverPubkey,
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
        [RelatedPubkey.tagName, receiverPubkey],
        ['k', contentKind.toString()],
        if (expirationTag != null) expirationTag,
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

    return EventMessage.fromPayloadJson(
      jsonDecode(decryptedContent) as Map<String, dynamic>,
    );
  }
}
