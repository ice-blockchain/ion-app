// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/user/model/interest_set.dart';
import 'package:nostr_dart/nostr_dart.dart';

void main() {
  NostrDart.configure(logLevel: NostrLogLevel.ALL);

  group('InterestsSet Tests', () {
    test('InterestSet.fromEventMessage should work when all data is there', () {
      final keyStore = KeyStore.generate();

      final testEvent = EventMessage.fromData(
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
