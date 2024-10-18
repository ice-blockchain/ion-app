// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/user/model/interest_set.dart';
import 'package:nostr_dart/nostr_dart.dart';

void main() {
  NostrDart.configure(logLevel: NostrLogLevel.ALL);

  group('InterestsSet Tests', () {
    test('InterestSet.fromEventMessage should work when all data is there', () {
      final keyStore = KeyStore.generate();

      final testEvent = EventMessage.fromData(
        signer: keyStore,
        kind: InterestSet.kind,
        tags: const [
          ['d', 'languages'],
          ['t', 'en'],
          ['t', 'es'],
        ],
        content: '',
      );

      final interestSet = InterestSet.fromEventMessage(testEvent);

      expect(interestSet, isA<InterestSet>());
      expect(interestSet.type, InterestSetType.languages);
      expect(interestSet.hashtags.length, 2);
      expect(interestSet.hashtags[0], 'en');
    });
  });
}
