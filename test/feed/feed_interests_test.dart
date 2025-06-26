// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.f.dart';
import 'package:ion/app/features/feed/data/models/feed_interests_interaction.dart';

void main() {
  group('FeedInterests.applyInteraction', () {
    final baseJson = {
      'sports': {
        'display': 'Sports',
        'weight': 4,
        'children': {
          'football': {'weight': 1, 'display': 'Football'},
          'tennis': {'weight': 2, 'display': 'Tennis'},
          'swimming': {'weight': 3, 'display': 'Swimming'},
        },
      },
      'gaming': {
        'weight': 10,
        'display': 'Gaming',
        'children': {
          'moba': {'weight': 1, 'display': 'MOBA'},
          'fps': {'weight': 2, 'display': 'FPS'},
          'rpg': {'weight': 3, 'display': 'RPG'},
        },
      },
      'crypto': {
        'weight': 3,
        'display': 'Crypto',
        'children': {
          'defi': {'weight': 1, 'display': 'DeFi'},
          'stablecoins': {'weight': 2, 'display': 'Stablecoins'},
          'nfts': {'weight': 3, 'display': 'NFTs'},
        },
      },
    };

    test('updates only category weight when category is targeted', () {
      final interests = FeedInterests.fromJson(baseJson);
      const interaction = FeedInterestInteraction.likeReply;
      final updated = interests.applyInteraction(interaction, ['sports']);
      expect(
        updated.categories['sports']!.weight,
        interests.categories['sports']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['football']!.weight,
        interests.categories['sports']!.children['football']!.weight,
      );
      expect(
        updated.categories['sports']!.children['tennis']!.weight,
        interests.categories['sports']!.children['tennis']!.weight,
      );
      expect(
        updated.categories['sports']!.children['swimming']!.weight,
        interests.categories['sports']!.children['swimming']!.weight,
      );
    });

    test('applies correct score depending on the interaction', () {
      final interests = FeedInterests.fromJson(baseJson);
      const interaction = FeedInterestInteraction.quote;
      final updated = interests.applyInteraction(interaction, ['sports']);
      expect(
        updated.categories['sports']!.weight,
        interests.categories['sports']!.weight + interaction.score,
      );
    });

    test('updates subcategory and parent category weight when subcategory is targeted', () {
      final interests = FeedInterests.fromJson(baseJson);
      const interaction = FeedInterestInteraction.likeReply;
      final updated = interests.applyInteraction(interaction, ['football']);
      expect(
        updated.categories['sports']!.weight,
        interests.categories['sports']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['football']!.weight,
        interests.categories['sports']!.children['football']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['tennis']!.weight,
        interests.categories['sports']!.children['tennis']!.weight,
      );
      expect(
        updated.categories['sports']!.children['swimming']!.weight,
        interests.categories['sports']!.children['swimming']!.weight,
      );
    });

    test('updates both category and subcategory weights if both are targeted', () {
      final interests = FeedInterests.fromJson(baseJson);
      const interaction = FeedInterestInteraction.likeReply;
      final updated = interests.applyInteraction(interaction, ['sports', 'football']);
      expect(
        updated.categories['sports']!.weight,
        interests.categories['sports']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['football']!.weight,
        interests.categories['sports']!.children['football']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['tennis']!.weight,
        interests.categories['sports']!.children['tennis']!.weight,
      );
      expect(
        updated.categories['sports']!.children['swimming']!.weight,
        interests.categories['sports']!.children['swimming']!.weight,
      );
    });

    test('updates two sibling subcategories and parent category weight when both are targeted', () {
      final interests = FeedInterests.fromJson(baseJson);
      const interaction = FeedInterestInteraction.likeReply;
      final updated = interests.applyInteraction(interaction, ['tennis', 'swimming']);
      expect(
        updated.categories['sports']!.weight,
        interests.categories['sports']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['tennis']!.weight,
        interests.categories['sports']!.children['tennis']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['swimming']!.weight,
        interests.categories['sports']!.children['swimming']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['football']!.weight,
        interests.categories['sports']!.children['football']!.weight,
      );
    });

    test('does not update anything if no matching categories or subcategories are targeted', () {
      final interests = FeedInterests.fromJson(baseJson);
      const interaction = FeedInterestInteraction.likeReply;
      final updated = interests.applyInteraction(interaction, ['nonexistent']);
      expect(
        updated.categories['sports']!.weight,
        interests.categories['sports']!.weight,
      );
      expect(
        updated.categories['sports']!.children['football']!.weight,
        interests.categories['sports']!.children['football']!.weight,
      );
      expect(
        updated.categories['gaming']!.weight,
        interests.categories['gaming']!.weight,
      );
      expect(
        updated.categories['crypto']!.weight,
        interests.categories['crypto']!.weight,
      );
    });

    test('updates category and two subcategories if all are targeted', () {
      final interests = FeedInterests.fromJson(baseJson);
      const interaction = FeedInterestInteraction.likeReply;
      final updated = interests.applyInteraction(interaction, ['sports', 'football', 'tennis']);
      expect(
        updated.categories['sports']!.weight,
        interests.categories['sports']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['football']!.weight,
        interests.categories['sports']!.children['football']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['tennis']!.weight,
        interests.categories['sports']!.children['tennis']!.weight + interaction.score,
      );
      expect(
        updated.categories['sports']!.children['swimming']!.weight,
        interests.categories['sports']!.children['swimming']!.weight,
      );
    });

    test('does not update unrelated categories or subcategories', () {
      final interests = FeedInterests.fromJson(baseJson);
      const interaction = FeedInterestInteraction.likeReply;
      final updated = interests.applyInteraction(interaction, ['gaming']);
      expect(
        updated.categories['sports']!.weight,
        interests.categories['sports']!.weight,
      );
      expect(
        updated.categories['crypto']!.weight,
        interests.categories['crypto']!.weight,
      );
      expect(
        updated.categories['gaming']!.weight,
        interests.categories['gaming']!.weight + interaction.score,
      );
    });
  });
}
