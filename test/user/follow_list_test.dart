// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';

void main() {
  NostrDart.configure();

  group('FollowList Tests', () {
    test('FollowList.fromEventMessage should work when all data is there', () async {
      final keyStore = await Ed25519KeyStore.generate();

      final testEvent = await EventMessage.fromData(
        signer: keyStore,
        kind: 3,
        tags: const [
          ['b', ''],
          ['p', '91cf9..4e5ca', 'wss://alicerelay.com/', 'alice'],
          ['p', '14aeb..8dad4', 'wss://bobrelay.com/nostr', 'bob'],
          ['p', '612ae..e610f', 'ws://carolrelay.com/ws', 'carol'],
        ],
        content: '',
      );

      final followList = FollowListEntity.fromEventMessage(testEvent);

      expect(followList, isA<FollowListEntity>());
      expect(followList.data.list.length, 3);
      expect(followList.data.list[1].pubkey, '14aeb..8dad4');
      expect(followList.data.list[1].relayUrl, 'wss://bobrelay.com/nostr');
      expect(followList.data.list[1].petname, 'bob');
    });
  });
}
