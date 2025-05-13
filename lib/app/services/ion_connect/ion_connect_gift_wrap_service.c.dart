// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/services/ion_connect/encrypted_message_service.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_gift_wrap_service.c.g.dart';

@riverpod
Future<IonConnectGiftWrapService> ionConnectGiftWrapService(Ref ref) async =>
    IonConnectGiftWrapServiceImpl(
      encryptedMessageService: await ref.watch(encryptedMessageServiceProvider.future),
    );

abstract class IonConnectGiftWrapService {
  Future<EventMessage> createWrap({
    required EventMessage event,
    required String receiverPubkey,
    required String receiverMasterPubkey,
    required List<String> contentKinds,
    List<String>? expirationTag,
  });

  Future<EventMessage> decodeWrap({
    required String content,
    required String senderPubkey,
    required String privateKey,
  });
}

class IonConnectGiftWrapServiceImpl implements IonConnectGiftWrapService {
  const IonConnectGiftWrapServiceImpl({
    required EncryptedMessageService encryptedMessageService,
  }) : _encryptedMessageService = encryptedMessageService;

  final EncryptedMessageService _encryptedMessageService;

  @override
  Future<EventMessage> createWrap({
    required EventMessage event,
    required String receiverPubkey,
    required String receiverMasterPubkey,
    required List<String> contentKinds,
    List<String>? expirationTag,
  }) async {
    final oneTimeSigner = await Ed25519KeyStore.generate();

    final encryptedEvent = await _encryptedMessageService.encryptMessage(
      jsonEncode(event.toJson().last),
      publicKey: receiverPubkey,
      privateKey: oneTimeSigner.privateKey,
    );

    final createdAt = randomDateBefore(
      const Duration(days: 2),
    );

    return EventMessage.fromData(
      kind: IonConnectGiftWrapEntity.kind,
      createdAt: createdAt,
      signer: oneTimeSigner,
      content: encryptedEvent,
      tags: [
        [RelatedPubkey.tagName, receiverMasterPubkey, '', receiverPubkey],
        ['k', ...contentKinds],
        if (expirationTag != null) expirationTag,
      ],
    );
  }

  @override
  Future<EventMessage> decodeWrap({
    required String content,
    required String senderPubkey,
    required String privateKey,
  }) async {
    final decryptedContent = await _encryptedMessageService.decryptMessage(
      content,
      publicKey: senderPubkey,
      privateKey: privateKey,
    );

    return EventMessage.fromPayloadJson(
      jsonDecode(decryptedContent) as Map<String, dynamic>,
    );
  }
}
