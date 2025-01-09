// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:nostr_dart/nostr_dart.dart';

void main() {
  NostrDart.configure();

  group('InterestsSet Tests', () {
    test('InterestSet.fromEventMessage should work when all data is there', () async {
      final keyStore = await Ed25519KeyStore.generate();

      final testEvent = await EventMessage.fromData(
        signer: keyStore,
        kind: 30015,
        tags: const [
          ['b', ''],
          ['d', 'languages'],
          ['t', 'en'],
          ['t', 'es'],
        ],
        content: '',
      );

      final interestSet = InterestSetEntity.fromEventMessage(testEvent);

      expect(interestSet, isA<InterestSetEntity>());
      expect(interestSet.data.type, InterestSetType.languages);
      expect(interestSet.data.hashtags.length, 2);
      expect(interestSet.data.hashtags[0], 'en');
    });
  });
}
