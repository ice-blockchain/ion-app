// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/utils/date.dart';
import 'package:nip44/nip44.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_gift_wrap_service.c.g.dart';

@riverpod
IonConnectGiftWrapService ionConnectGiftWrapService(Ref ref) => IonConnectGiftWrapServiceImpl();

abstract class IonConnectGiftWrapService {
  Future<EventMessage> createWrap(
    EventMessage event,
    String receiverPubkey,
    EventSigner signer,
    int contentKind, {
    List<String>? expirationTag,
  });

  Future<EventMessage> decodeWrap(
    String content,
    String pubkey,
    EventSigner signer,
  );
}

class IonConnectGiftWrapServiceImpl implements IonConnectGiftWrapService {
  static const int kind = 1059;

  @override
  Future<EventMessage> createWrap(
    EventMessage event,
    String receiverPubkey,
    EventSigner signer,
    int contentKind, {
    List<String>? expirationTag,
  }) async {
    final conversationKey = Nip44.deriveConversationKey(
      await Ed25519KeyStore.getSharedSecret(
        privateKey: signer.privateKey,
        publicKey: receiverPubkey,
      ),
    );

    final encryptedEvent = await Nip44.encryptMessage(
      jsonEncode(event.toJson().last),
      signer.privateKey,
      receiverPubkey,
      customConversationKey: conversationKey,
    );

    final createdAt = randomDateBefore(
      const Duration(days: 2),
    );

    return EventMessage.fromData(
      signer: signer,
      kind: kind,
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
    String content,
    String pubkey,
    EventSigner signer,
  ) async {
    final conversationKey = Nip44.deriveConversationKey(
      await Ed25519KeyStore.getSharedSecret(privateKey: signer.privateKey, publicKey: pubkey),
    );

    final decryptedContent = await Nip44.decryptMessage(
      content,
      signer.privateKey,
      pubkey,
      customConversationKey: conversationKey,
    );

    return EventMessage.fromPayloadJson(
      jsonDecode(decryptedContent) as Map<String, dynamic>,
    );
  }
}
