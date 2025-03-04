// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/services/ion_connect/ion_connect_e2ee_service.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_gift_wrap_service.c.g.dart';

@riverpod
Future<IonConnectGiftWrapService> ionConnectGiftWrapService(Ref ref) async =>
    IonConnectGiftWrapServiceImpl(
      e2eeService: await ref.read(ionConnectE2eeServiceProvider.future),
    );

abstract class IonConnectGiftWrapService {
  Future<EventMessage> createWrap({
    required EventMessage event,
    required String receiverPubkey,
    required String receiverMasterPubkey,
    required int contentKind,
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
    required IonConnectE2eeService e2eeService,
  }) : _e2eeService = e2eeService;

  static const int kind = 1059;
  final IonConnectE2eeService _e2eeService;

  @override
  Future<EventMessage> createWrap({
    required EventMessage event,
    required String receiverPubkey,
    required String receiverMasterPubkey,
    required int contentKind,
    List<String>? expirationTag,
  }) async {
    final oneTimeSigner = await Ed25519KeyStore.generate();

    final encryptedEvent = await _e2eeService.encryptMessage(
      jsonEncode(event.toJson().last),
      publicKey: receiverPubkey,
      privateKey: oneTimeSigner.privateKey,
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
        [RelatedPubkey.tagName, receiverMasterPubkey, '', receiverPubkey],
        ['k', contentKind.toString()],
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
    final decryptedContent = await _e2eeService.decryptMessage(
      content,
      publicKey: senderPubkey,
      privateKey: privateKey,
    );

    return EventMessage.fromPayloadJson(
      jsonDecode(decryptedContent) as Map<String, dynamic>,
    );
  }
}
