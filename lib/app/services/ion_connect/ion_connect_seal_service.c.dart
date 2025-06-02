// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/string.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/master_pubkey_tag.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/encrypted_message_service.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_seal_service.c.g.dart';

@riverpod
Future<IonConnectSealService> ionConnectSealService(Ref ref) async => IonConnectSealServiceImpl(
      currentUserMasterPubkey: ref.watch(currentPubkeySelectorProvider).emptyOrValue,
      encryptedMessageService: await ref.watch(encryptedMessageServiceProvider.future),
    );

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
    required this.currentUserMasterPubkey,
    required EncryptedMessageService encryptedMessageService,
  }) : _encryptedMessageService = encryptedMessageService;

  static const int kind = 13;

  final String currentUserMasterPubkey;
  final EncryptedMessageService _encryptedMessageService;

  @override
  Future<EventMessage> createSeal(
    EventMessage rumor,
    EventSigner signer,
    String receiverPubkey,
  ) async {
    final encodedRumor = jsonEncode(rumor.toJson().last);

    final encryptedRumor = await _encryptedMessageService.encryptMessage(
      encodedRumor,
      publicKey: receiverPubkey,
      privateKey: signer.privateKey,
    );

    final createdAt = randomDateBefore(
      const Duration(days: 2),
    ).microsecondsSinceEpoch;

    if (currentUserMasterPubkey.isEmpty) {
      throw UserMasterPubkeyNotFoundException();
    }

    return EventMessage.fromData(
      kind: kind,
      signer: signer,
      createdAt: createdAt,
      content: encryptedRumor,
      tags: [
        MasterPubkeyTag(value: currentUserMasterPubkey).toTag(),
      ],
    );
  }

  @override
  Future<EventMessage> decodeSeal(
    String content,
    String senderPubkey,
    String privateKey,
  ) async {
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
