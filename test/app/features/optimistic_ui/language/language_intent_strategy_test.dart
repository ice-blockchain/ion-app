// SPDX-License-Identifier: ICE License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/optimistic_ui/features/language/change_language_intent.dart';
import 'package:ion/app/features/optimistic_ui/features/language/language_sync_strategy.dart';
import 'package:ion/app/features/settings/model/content_lang_set.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';

void main() {
  group('ChangeLanguageIntent', () {
    const base = ContentLangSet(pubkey: 'pubkey1', hashtags: ['en']);

    test('adds ISO when not present, keeps sorted order', () {
      final intent = ChangeLanguageIntent('fr');
      final optimistic = intent.optimistic(base);

      expect(optimistic.hashtags, equals(['en', 'fr']));
    });

    test('removes ISO when already present', () {
      final intent = ChangeLanguageIntent('en');
      final optimistic = intent.optimistic(base);

      expect(optimistic.hashtags, isEmpty);
    });
  });

  group('LanguageSyncStrategy', () {
    test('sends InterestSetData with correct hashtags', () async {
      late InterestSetData captured;
      final strategy = LanguageSyncStrategy(
        sendInterestSet: (data) async => captured = data,
      );

      const prev = ContentLangSet(pubkey: 'pubkey1', hashtags: ['en']);
      const next = ContentLangSet(pubkey: 'pubkey1', hashtags: ['en', 'fr']);

      final result = await strategy.send(prev, next);

      expect(result, same(next), reason: 'Should return optimistic state');
      expect(captured.type, InterestSetType.languages);
      expect(captured.hashtags, equals(['en', 'fr']));
    });
  });
}
