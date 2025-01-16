// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';

void main() {
  late IonConnectGiftWrapService giftWrapService;
  late EventSigner signer;
  late String pubkey;

  setUp(() async {
    giftWrapService = IonConnectGiftWrapServiceImpl();
    signer = await Ed25519KeyStore.generate();
    pubkey = (await Ed25519KeyStore.generate()).publicKey;
  });

  group('IonConnectGiftWrapService', () {
    test('creates wrap from event', () async {
      final event =
          await PrivateDirectMessageData.fromRawContent('test').toEventMessage(pubkey: pubkey);

      final wrap = await giftWrapService.createWrap(
        event,
        pubkey,
        signer,
        PrivateDirectMessageEntity.kind,
      );

      expect(wrap.kind, equals(1059));
      expect(wrap.content, isNotEmpty);
      expect(wrap.content, isNot(equals(event.content)));
      expect(wrap.tags, hasLength(2));
      expect(wrap.tags[0][0], equals('p'));
      expect(wrap.tags[0][1], equals(pubkey));
      expect(wrap.tags[1][0], equals('k'));
      expect(wrap.tags[1][1], equals('14'));
    });

    test('decodes wrap back to original event', () async {
      final event =
          await PrivateDirectMessageData.fromRawContent('test').toEventMessage(pubkey: pubkey);

      final wrap = await giftWrapService.createWrap(
        event,
        pubkey,
        signer,
        PrivateDirectMessageEntity.kind,
      );

      final decodedWrap = await giftWrapService.decodeWrap(
        wrap.content,
        pubkey,
        signer,
      );

      expect(decodedWrap.kind, equals(14));
      expect(decodedWrap.content, equals(event.content));
      expect(decodedWrap.tags, equals(event.tags));
    });
  });
}
