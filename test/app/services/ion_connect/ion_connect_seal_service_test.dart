// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/services/ion_connect/encrypted_message_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';

void main() {
  late IonConnectSealService sealService;
  late EventSigner senderSigner;
  late EventSigner receiverSigner;

  setUp(() async {
    senderSigner = await Ed25519KeyStore.generate();
    receiverSigner = await Ed25519KeyStore.generate();

    final encryptedMessageService = EncryptedMessageService(
      eventSigner: senderSigner,
      currentUserPubkey: senderSigner.publicKey,
    );

    sealService = IonConnectSealServiceImpl(encryptedMessageService: encryptedMessageService);
  });

  group('IonConnectSealService', () {
    test('creates seal from rumor on sender side', () async {
      final rumor = await PrivateDirectMessageData.fromRawContent('test')
          .toEventMessage(pubkey: senderSigner.publicKey);

      final seal = await sealService.createSeal(
        rumor,
        senderSigner,
        senderSigner.publicKey,
      );

      expect(seal.kind, equals(13));
      expect(seal.pubkey, equals(senderSigner.publicKey));
      expect(seal.content, isNotEmpty);
      expect(seal.content, isNot(equals(rumor.content)));
      expect(seal.tags, isEmpty);
    });

    test('decodes seal back to original event on senders side', () async {
      final rumor = await PrivateDirectMessageData.fromRawContent('test')
          .toEventMessage(pubkey: senderSigner.publicKey);

      final seal = await sealService.createSeal(
        rumor,
        senderSigner,
        senderSigner.publicKey,
      );

      final decodedSeal = await sealService.decodeSeal(
        seal.content!,
        senderSigner.publicKey,
        senderSigner.privateKey,
      );

      expect(decodedSeal.kind, equals(14));
      expect(decodedSeal.content, equals(rumor.content));
      expect(decodedSeal.tags, equals(rumor.tags));
    });

    test('decodes seal back to original event on receivers side', () async {
      final rumor = await PrivateDirectMessageData.fromRawContent('test')
          .toEventMessage(pubkey: senderSigner.publicKey);

      final seal = await sealService.createSeal(
        rumor,
        senderSigner,
        receiverSigner.publicKey,
      );

      final decodedSeal = await sealService.decodeSeal(
        seal.content!,
        senderSigner.publicKey,
        receiverSigner.privateKey,
      );

      expect(decodedSeal.kind, equals(14));
      expect(decodedSeal.content, equals(rumor.content));
      expect(decodedSeal.tags, equals(rumor.tags));
    });
  });
}
