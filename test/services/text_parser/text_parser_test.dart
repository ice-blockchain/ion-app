// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/services/text_parser/data/models/text_matcher.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';

void main() {
  group('TextParser', () {
    late TextParser parser;

    setUp(() {
      parser = TextParser.allMatchers();
    });

    test('should parse mentions correctly', () {
      final results = parser.parse('Hello @user1 and @user2');

      expect(results.length, equals(4));
      expect(results[0].text, equals('Hello '));
      expect(results[1].text, equals('@user1'));
      expect(results[1].matcher, isA<MentionMatcher>());
      expect(results[2].text, equals(' and '));
      expect(results[3].text, equals('@user2'));
      expect(results[3].matcher, isA<MentionMatcher>());

      expect(results.length, 4);
    });

    test('should parse hashtags correctly', () {
      final results = parser.parse('Check out #flutter and #dart');

      expect(results.length, equals(4));
      expect(results[0].text, equals('Check out '));
      expect(results[1].text, equals('#flutter'));
      expect(results[1].matcher, isA<HashtagMatcher>());
      expect(results[2].text, equals(' and '));
      expect(results[3].text, equals('#dart'));
      expect(results[3].matcher, isA<HashtagMatcher>());

      expect(results.length, 4);
    });

    test('should parse URLs correctly', () {
      final results = parser.parse('Visit https://example.com and http://test.org');

      expect(results.length, equals(4));
      expect(results[0].text, equals('Visit '));
      expect(results[1].text, equals('https://example.com'));
      expect(results[1].matcher, isA<UrlMatcher>());
      expect(results[2].text, equals(' and '));
      expect(results[3].text, equals('http://test.org'));
      expect(results[3].matcher, isA<UrlMatcher>());

      expect(results.length, 4);
    });

    test('should parse mixed content correctly', () {
      final results = parser.parse(
        'Hey @john, check #trending at https://example.com!',
      );

      expect(results.length, equals(7));
      expect(results[0].text, equals('Hey '));
      expect(results[1].text, equals('@john'));
      expect(results[1].matcher, isA<MentionMatcher>());
      expect(results[2].text, equals(', check '));
      expect(results[3].text, equals('#trending'));
      expect(results[3].matcher, isA<HashtagMatcher>());
      expect(results[4].text, equals(' at '));
      expect(results[5].text, equals('https://example.com'));
      expect(results[5].matcher, isA<UrlMatcher>());
      expect(results[6].text, equals('!'));

      expect(results.length, 7);
    });

    test('should handle empty text correctly', () {
      final results = parser.parse('');
      expect(results, isEmpty);
    });

    test('should parse with onlyMatches=true correctly', () {
      final results = parser.parse(
        'Hey @john, check #trending!',
        onlyMatches: true,
      );

      expect(results.length, equals(2));
      expect(results[0].text, equals('@john'));
      expect(results[0].matcher, isA<MentionMatcher>());
      expect(results[1].text, equals('#trending!'));
      expect(results[1].matcher, isA<HashtagMatcher>());

      expect(results.length, 2);
    });

    test('should preserve correct offsets', () {
      final results = parser.parse('Hi @user #tag');

      expect(results[0].offset, equals(0));
      expect(results[1].offset, equals(3));
      expect(results[2].offset, equals(8));
      expect(results[3].offset, equals(9));

      expect(results.length, 4);
    });

    test('should throw assertion error when no matchers provided', () {
      expect(
        () => TextParser(matchers: const {}),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
