// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
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
    EventSigner signer,
    String pubkey,
  );
}

class IonConnectSealServiceImpl implements IonConnectSealService {
  static const int sealKind = 13;

  @override
  Future<EventMessage> createSeal(
    EventMessage rumor,
    EventSigner signer,
    String receiverPubkey,
  ) async {
    final encodedRumor = jsonEncode(rumor.toJson().last);

    final encryptedRumor = await Nip44.encryptMessage(
      encodedRumor,
      signer.privateKey,
      receiverPubkey,
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
    String pubkey,
  ) async {
    final decryptedContent = await Nip44.decryptMessage(
      seal.content,
      signer.privateKey,
      pubkey,
    );

    return EventMessage.fromPayloadJson(
      jsonDecode(decryptedContent) as Map<String, dynamic>,
    );
  }
}
