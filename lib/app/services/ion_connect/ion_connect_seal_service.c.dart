// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ion_connect_e2ee_service.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_seal_service.c.g.dart';

@riverpod
Future<IonConnectSealService> ionConnectSealService(Ref ref) async =>
    IonConnectSealServiceImpl(e2eeService: await ref.read(ionConnectE2eeServiceProvider.future));

abstract class IonConnectSealService {
  Future<EventMessage> createSeal(
    EventMessage rumor,
    EventSigner signer,
    String receiverPubkey,
  );

  Future<EventMessage> decodeSeal(
    String content,
    String senderPubkey,
    String privateKey,
  );
}

class IonConnectSealServiceImpl implements IonConnectSealService {
  const IonConnectSealServiceImpl({
    required IonConnectE2eeService e2eeService,
  }) : _e2eeService = e2eeService;

  static const int kind = 13;

  final IonConnectE2eeService _e2eeService;

  @override
  Future<EventMessage> createSeal(
    EventMessage rumor,
    EventSigner signer,
    String receiverPubkey,
  ) async {
    final encodedRumor = jsonEncode(rumor.toJson().last);

    final encryptedRumor = await _e2eeService.encryptMessage(
      encodedRumor,
      publicKey: receiverPubkey,
      privateKey: signer.privateKey,
    );

    final createdAt = randomDateBefore(
      const Duration(days: 2),
    );

    return EventMessage.fromData(
      kind: kind,
      signer: signer,
      createdAt: createdAt,
      content: encryptedRumor,
    );
  }

  @override
  Future<EventMessage> decodeSeal(
    String content,
    String senderPubkey,
    String privateKey,
  ) async {
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
