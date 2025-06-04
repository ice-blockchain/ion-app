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
      );
      interests = FeedInterests.fromJson({
        'music': {
          'weight': 2,
          'children': {
            'rock': {'weight': 10},
            'pop': {'weight': 1},
          },
        },
        'sports': {
          'weight': 10,
          'children': {
            'basketball': {'weight': 2},
            'football': {'weight': 5},
          },
        },
      });
      random = MockRandom();

      when(() => random.nextDouble()).thenReturn(Random().nextDouble());
      when(() => random.nextInt(any())).thenReturn(0);
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
  });
}
