// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/services/ion_connect/ion_connect_e2ee_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late IonConnectGiftWrapService giftWrapService;
  late EventSigner senderSigner;
  late EventSigner receiverSigner;

  setUp(() async {
    senderSigner = await Ed25519KeyStore.generate();
    receiverSigner = await Ed25519KeyStore.generate();
    final e2eeService = IonConnectE2eeService(
      eventSigner: senderSigner,
      currentUserPubkey: senderSigner.publicKey,
    );
    giftWrapService = IonConnectGiftWrapServiceImpl(e2eeService: e2eeService);
  });

  group('IonConnectGiftWrapService', () {
    test('creates wrap from event', () async {
      final event = await PrivateDirectMessageData.fromRawContent('test')
          .toEventMessage(pubkey: senderSigner.publicKey);

      const masterPubkey = '0';

      final wrap = await giftWrapService.createWrap(
        event: event,
        receiverMasterpubkey: masterPubkey,
        receiverPubkey: receiverSigner.publicKey,
        contentKind: PrivateDirectMessageEntity.kind,
      );

      expect(wrap.kind, equals(1059));
      expect(wrap.content, isNotEmpty);
      expect(wrap.content, isNot(equals(event.content)));
      expect(wrap.tags, hasLength(2));
      expect(wrap.tags[0][0], equals('p'));
      expect(wrap.tags[0][1], equals(masterPubkey));
      expect(wrap.tags[0][3], equals(receiverSigner.publicKey));
      expect(wrap.tags[1][0], equals('k'));
      expect(wrap.tags[1][1], equals('14'));
    });

    test('decodes wrap back to original event on senders side', () async {
      final event = await PrivateDirectMessageData.fromRawContent('test')
          .toEventMessage(pubkey: senderSigner.publicKey);

      final wrap = await giftWrapService.createWrap(
        event: event,
        receiverMasterpubkey: "Doesn't matter",
        receiverPubkey: senderSigner.publicKey,
        contentKind: PrivateDirectMessageEntity.kind,
      );

      final decodedWrap = await giftWrapService.decodeWrap(
        content: wrap.content,
        senderPubkey: wrap.pubkey,
        privateKey: senderSigner.privateKey,
      );

      expect(decodedWrap.kind, equals(14));
      expect(decodedWrap.content, equals(event.content));
      expect(decodedWrap.tags, equals(event.tags));
    });

    test('decodes wrap back to original event on receivers side', () async {
      final event = await PrivateDirectMessageData.fromRawContent('test')
          .toEventMessage(pubkey: senderSigner.publicKey);

      final wrap = await giftWrapService.createWrap(
        event: event,
        receiverMasterpubkey: "Doesn't matter",
        receiverPubkey: receiverSigner.publicKey,
        contentKind: PrivateDirectMessageEntity.kind,
      );

      final decodedWrap = await giftWrapService.decodeWrap(
        content: wrap.content,
        senderPubkey: wrap.pubkey,
        privateKey: receiverSigner.privateKey,
      );

      expect(decodedWrap.kind, equals(14));
      expect(decodedWrap.content, equals(event.content));
      expect(decodedWrap.tags, equals(event.tags));
    });
  });
}
