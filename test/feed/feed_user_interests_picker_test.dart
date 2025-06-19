// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/models/feed_config.c.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.c.dart';
import 'package:ion/app/features/feed/providers/feed_user_interest_picker_provider.c.dart';
import 'package:mocktail/mocktail.dart';

class MockRandom extends Mock implements Random {}

void main() {
  group('FeedUserInterestPicker', () {
    late FeedConfig config;
    late FeedInterests interests;
    late Random random;

    setUp(() {
      config = const FeedConfig(
        interestedThreshold: 0.5,
        notInterestedCategoryChance: 0.5,
        notInterestedSubcategoryChance: 0.5,
        followingReqMaxAge: Duration(days: 1),
        followingCacheMaxAge: Duration(days: 2),
        topMaxAge: Duration(days: 1),
        trendingMaxAge: Duration(days: 1),
        exploreMaxAge: Duration(days: 1),
        repostThrottleDelay: Duration(days: 1),
        concurrentRequests: 3,
        concurrentMediaDownloadsLimit: 3,
      );
      interests = FeedInterests.fromJson({
        'music': {
          'weight': 2,
          'display': 'Music',
          'children': {
            'rock': {'weight': 10, 'display': 'Rock'},
            'pop': {'weight': 1, 'display': 'Pop'},
          },
        },
        'sports': {
          'weight': 10,
          'display': 'Sports',
          'children': {
            'basketball': {'weight': 2, 'display': 'Basketball'},
            'football': {'weight': 5, 'display': 'Football'},
          },
        },
      });
      random = MockRandom();

      when(() => random.nextDouble()).thenReturn(Random().nextDouble());
      when(() => random.nextInt(any(that: isA<int>()))).thenAnswer((invocation) {
        final n = invocation.positionalArguments.first as int;
        if (n <= 0) {
          throw ArgumentError.value(n, 'n', 'Must be positive');
        }
        return 0;
      });
    });

    test('rolls a random (first) category and sub-category', () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(notInterestedCategoryChance: 1),
        interests: interests,
        random: random,
      );
      final result = picker.roll();
      expect(result, equals('rock'));
    });

    test('rolls a random (first) subcategory from interested category', () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 0,
          notInterestedSubcategoryChance: 1,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll();
      expect(result, equals('basketball'));
    });

    test('rolls an interested subcategory from interested category', () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 0,
          notInterestedSubcategoryChance: 0,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll();
      expect(result, equals('football'));
    });

    test(
        'rolls a random subcategory if there are no interested categories and interested chance is 100%',
        () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 0,
          notInterestedSubcategoryChance: 0,
          interestedThreshold: 1,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll();
      expect(result, equals('rock'));
    });

    test(
        'rolls a random subcategory if there are no not-interested categories and not-interested chance is 100%',
        () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 1,
          notInterestedSubcategoryChance: 1,
          interestedThreshold: 0,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll();
      expect(result, equals('rock'));
    });

    test('rolls only from allowedSubcategories if provided', () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 1,
          notInterestedSubcategoryChance: 1,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll(['pop', 'football']);
      expect(result, equals('pop'));
    });

    test('rolls null if no allowed provided', () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 1,
          notInterestedSubcategoryChance: 1,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll([]);
      expect(result, isNull);
    });

    test('rolls null if unknown subcategories are provided', () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 1,
          notInterestedSubcategoryChance: 1,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll(['foo', 'bar']);
      expect(result, isNull);
    });

    test(
        'rolls a random subcategory from allowedSubcategories if there are no interested categories and interested chance is 100%',
        () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 0,
          notInterestedSubcategoryChance: 0,
          interestedThreshold: 1,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll(['pop', 'basketball']);
      expect(result, equals('pop'));
    });

    test('rolls a random subcategory from allowedSubcategories, taking the interested category',
        () {
      final picker = FeedUserInterestPicker(
        config: config.copyWith(
          notInterestedCategoryChance: 0,
          notInterestedSubcategoryChance: 0,
        ),
        interests: interests,
        random: random,
      );
      final result = picker.roll(['pop', 'basketball']);
      // "sports" is an interested category, but there are no interested subcategories
      // from allowed list there, so taking a random allowed subcategory.
      expect(result, equals('basketball'));
    });
  });
}
