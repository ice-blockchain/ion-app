import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/services/nostr/nostr_gift_wrap_service.dart';
import 'package:nostr_dart/nostr_dart.dart';

void main() {
  late NostrGiftWrapService giftWrapService;
  late EventSigner signer;
  const pubkey = 'c95c07ad5aad2d81a3890f13b3eaa80a3d8aca173a91dc2be9fd04720a5a9377';

  setUp(() {
    giftWrapService = NostrGiftWrapServiceImpl();
    signer = KeyStore.generate();
  });

  group('NostrGiftWrapService', () {
    test('creates wrap from event', () async {
      final event = await EventMessage.fromData(
        signer: signer,
        kind: 14,
        content: 'test message',
        createdAt: DateTime.now(),
      );

      final wrap = await giftWrapService.createWrap(
        event,
        pubkey,
        signer,
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
      final event = await EventMessage.fromData(
        signer: signer,
        kind: 14,
        content: 'test message',
        createdAt: DateTime.now(),
      );

      final wrap = await giftWrapService.createWrap(
        event,
        pubkey,
        signer,
      );

      final decodedWrap = await giftWrapService.decodeWrap(
        wrap,
        pubkey,
        signer,
      );

      expect(decodedWrap.kind, equals(14));
      expect(decodedWrap.content, equals(event.content));
      expect(decodedWrap.tags, equals(event.tags));
    });
  });
}
