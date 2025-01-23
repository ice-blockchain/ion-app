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
    int contentKind, {
    List<String>? expirationTag,
  });

  Future<EventMessage> decodeWrap(
    String content,
    String senderPubkey,
    EventSigner signer,
  );
}

class IonConnectGiftWrapServiceImpl implements IonConnectGiftWrapService {
  static const int kind = 1059;

  @override
  Future<EventMessage> createWrap(
    EventMessage event,
    String receiverPubkey,
    int contentKind, {
    List<String>? expirationTag,
  }) async {
    final oneTimeSigner = await Ed25519KeyStore.generate();

    final conversationKey = await Ed25519KeyStore.getSharedSecret(
      privateKey: oneTimeSigner.privateKey,
      publicKey: receiverPubkey,
    );

    final encryptedEvent = await Nip44.encryptMessage(
      jsonEncode(event.toJson().last),
      oneTimeSigner.privateKey,
      receiverPubkey,
      customConversationKey: conversationKey,
    );

    final createdAt = randomDateBefore(
      const Duration(days: 2),
    );

    return EventMessage.fromData(
      kind: kind,
      createdAt: createdAt,
      signer: oneTimeSigner,
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
    String senderPubkey,
    EventSigner signer,
  ) async {
    final conversationKey = await Ed25519KeyStore.getSharedSecret(
        privateKey: signer.privateKey, publicKey: senderPubkey,);

    final decryptedContent = await Nip44.decryptMessage(
      content,
      signer.privateKey,
      senderPubkey,
      customConversationKey: conversationKey,
    );

    return EventMessage.fromPayloadJson(
      jsonDecode(decryptedContent) as Map<String, dynamic>,
    );
  }
}
