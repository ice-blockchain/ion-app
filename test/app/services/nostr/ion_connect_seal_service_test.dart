// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/services/nostr/ed25519_key_store.dart';
import 'package:ion/app/services/nostr/ion_connect_seal_service.dart';
import 'package:nostr_dart/nostr_dart.dart';

void main() {
  late IOnConnectSealService sealService;
  late EventSigner signer;
  const pubkey = 'c95c07ad5aad2d81a3890f13b3eaa80a3d8aca173a91dc2be9fd04720a5a9377';

  setUp(() async {
    sealService = IonConnectSealServiceImpl();
    signer = await Ed25519KeyStore.generate();
  });

  group('IonConnectSealService', () {
    test('creates seal from rumor', () async {
      final rumor =
          await PrivateDirectMessageData.fromRawContent('test').toEventMessage(pubkey: pubkey);

      final seal = await sealService.createSeal(
        rumor,
        signer,
        pubkey,
      );

      expect(seal.kind, equals(13));
      expect(seal.content, isNotEmpty);
      expect(seal.content, isNot(equals(rumor.content)));
      expect(seal.tags, isEmpty);
    });

    //TODO: Investigate why this is failing on CI
    // test('decodes seal back to original event', () async {
    //   final rumor =
    //       await PrivateDirectMessageData.fromRawContent('test').toEventMessage(pubkey: pubkey);

    //   final seal = await sealService.createSeal(
    //     rumor,
    //     signer,
    //     pubkey,
    //   );

    //   final decodedSeal = await sealService.decodeSeal(
    //     seal,
    //     signer,
    //     pubkey,
    //   );

    //   expect(decodedSeal.kind, equals(14));
    //   expect(decodedSeal.content, equals(rumor.content));
    //   expect(decodedSeal.tags, equals(rumor.tags));
    // });
  });
}
