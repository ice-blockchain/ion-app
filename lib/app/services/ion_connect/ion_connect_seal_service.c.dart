// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/utils/date.dart';
import 'package:nip44/nip44.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_seal_service.c.g.dart';

@riverpod
IonConnectSealService ionConnectSealService(Ref ref) => IonConnectSealServiceImpl();

abstract class IonConnectSealService {
  Future<EventMessage> createSeal(
    EventMessage rumor,
    EventSigner signer,
    String receiverPubkey,
  );

  Future<EventMessage> decodeSeal(
    EventMessage seal,
    String privateKey,
    String pubkey,
  );
}

class IonConnectSealServiceImpl implements IonConnectSealService {
  static const int kind = 13;

  @override
  Future<EventMessage> createSeal(
    EventMessage rumor,
    EventSigner signer,
    String receiverPubkey,
  ) async {
    final encodedRumor = jsonEncode(rumor.toJson().last);

    final conversationKey = Nip44.deriveConversationKey(
      await Ed25519KeyStore.getSharedSecret(
        privateKey: signer.privateKey,
        publicKey: receiverPubkey,
      ),
    );

    final encryptedRumor = await Nip44.encryptMessage(
      encodedRumor,
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
      content: encryptedRumor,
    );
  }

  @override
  Future<EventMessage> decodeSeal(
    EventMessage seal,
    String privateKey,
    String pubkey,
  ) async {
    final conversationKey = Nip44.deriveConversationKey(
      await Ed25519KeyStore.getSharedSecret(privateKey: privateKey, publicKey: pubkey),
    );

    final decryptedContent = await Nip44.decryptMessage(
      seal.content,
      privateKey,
      pubkey,
      customConversationKey: conversationKey,
    );

    return EventMessage.fromPayloadJson(
      jsonDecode(decryptedContent) as Map<String, dynamic>,
    );
  }
}
