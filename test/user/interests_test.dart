// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/chat/community/data/models/entities/tags/master_pubkey_tag.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user/data/models/interests.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';

void main() {
  NostrDart.configure();

  group('Interests Tests', () {
    test('Interests.fromEventMessage should work when all data is there', () async {
      final keyStore = await Ed25519KeyStore.generate();

      final testEvent = await EventMessage.fromData(
        signer: keyStore,
        kind: 10015,
        tags: const [
          [MasterPubkeyTag.tagName, 'value'],
          ['t', 'tag'],
          ['a', '2:13:123'],
          ['a', '3:222:123'],
        ],
        content: '',
      );

      final interest = InterestsEntity.fromEventMessage(testEvent);

      expect(interest, isA<InterestsEntity>());
      expect(interest.data.hashtags.length, 1);
      expect(interest.data.interestSetRefs.length, 2);
      expect(interest.data.hashtags[0], 'tag');
      expect(
        interest.data.interestSetRefs[0],
        const ReplaceableEventReference(kind: 2, pubkey: '13', dTag: '123'),
      );
    });
  });
}
