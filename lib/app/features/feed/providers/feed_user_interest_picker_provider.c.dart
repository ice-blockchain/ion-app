// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/feed_config.c.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.c.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_config_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_user_interest_picker_provider.c.g.dart';

class FeedUserInterestPicker {
  FeedUserInterestPicker({
    required FeedConfig config,
    required FeedInterests interests,
    required Random random,
  })  : _config = config,
        _interests = interests,
        _random = random,
        _interested = _calculateInterested(interests.categories, config: config);

  final FeedConfig _config;

  final FeedInterests _interests;

  final Random _random;

  final List<String> _interested;

  /// Rolls a random subcategory based on the user's interests and the configuration.
  ///
  /// Only the [allowedSubcategories] are considered, if provided.
  String? roll([List<String>? allowedSubcategories]) {
    final categories = _getAllowedCategories(allowedSubcategories);

    if (_roll(_config.notInterestedCategoryChance)) {
      // if rolled the scenario where we have to pick a parent category
      // the user is not interested in, we pick an entirely random child
      // of an entirely random parent.
      return _getRandomInterest(categories);
    }

    final interestedCategory = _getRandomInterestedByWeight(categories);
    if (interestedCategory == null) return _getRandomInterest(categories);

    if (_roll(_config.notInterestedSubcategoryChance)) {
      // If rolled the scenario where you have to pick a child category
      // the user is not interested in, we pick an entirely random child
      // of that parent.
      return _getRandomItem(interestedCategory.value.children.keys);
    }

    return _getRandomInterestedByWeight(interestedCategory.value.children)?.key;
  }

  String? _getRandomInterest(Map<String, FeedInterestsCategory> categories) {
    final randomCategory = _getRandomItem(categories.values);
    return _getRandomItem(randomCategory?.children.keys ?? []);
  }

  bool _roll(double chance) => chance > _random.nextDouble();

  T? _getRandomItem<T>(Iterable<T> items) => items.elementAtOrNull(_random.nextInt(items.length));

  Map<String, FeedInterestsCategory> _getAllowedCategories([List<String>? allowedSubcategories]) {
    if (allowedSubcategories == null) return _interests.categories;

    final filteredCategories = _interests.categories.entries.map((category) {
      final filteredSubcategories = category.value.children.entries
          .where((subcategory) => allowedSubcategories.contains(subcategory.key))
          .nonNulls;

      return filteredSubcategories.isNotEmpty
          ? MapEntry(
              category.key,
              category.value.copyWith(children: Map.fromEntries(filteredSubcategories)),
            )
          : null;
    }).nonNulls;

    return Map.fromEntries(filteredCategories);
  }

  /// Returns a random interested item from the given node.
  /// Weight is taken into account, so items with higher weight are more likely to be picked.
  ///
  /// For example, for a node with children [{weight: 1}, {weight: 3}],
  /// the first item has a 25% chance of being picked,
  /// while the second item has a 75% chance.
  MapEntry<String, T>? _getRandomInterestedByWeight<T extends CategoryWithWeight>(
    Map<String, T> node,
  ) {
    final interestedItems = node.entries.where((entry) => _interested.contains(entry.key)).toList();

    final totalInterestedWeight = interestedItems.fold<int>(
      0,
      (sum, item) => sum + item.value.weight,
    );

    final roll = _random.nextInt(totalInterestedWeight);

    var sum = 0;
    for (var i = 0; i < interestedItems.length; i++) {
      sum += interestedItems[i].value.weight;
      if (roll < sum) {
        return interestedItems[i];
      }
    }

    return _getRandomItem(interestedItems);
  }

  /// Returns a List of interested categories and subcategories.
  ///
  /// An item is considered "interesting" to the user if its weight
  /// is bigger than the threshold multiplied by the total weight of all sibling
  /// items under the same parent.
  static List<String> _calculateInterested(
    Map<String, FeedInterestsCategory> categories, {
    required FeedConfig config,
  }) {
    return [
      ..._getInterested(categories, config: config),
      ...categories.entries
          .map((entry) => _getInterested(entry.value.children, config: config))
          .expand((results) => results),
    ];
  }

  static List<String> _getInterested<T extends CategoryWithWeight>(
    Map<String, T> node, {
    required FeedConfig config,
  }) {
    final entries = node.entries.toList();
    final totalWeight = entries.fold<int>(0, (sum, item) => sum + item.value.weight);

    if (totalWeight == 0) {
      return [];
    }

    final minInterestedWeight = config.interestedThreshold * totalWeight;

    final interested = entries.where((item) => item.value.weight >= minInterestedWeight).toList();

    return interested.map((item) => item.key).toList();
  }
}

typedef InterestedItems<T extends CategoryWithWeight> = ({
  List<MapEntry<String, T>> items,
  int totalWeight
});

@riverpod
Future<FeedUserInterestPicker> feedUserInterestPicker(Ref ref, FeedType feedType) async {
  final interests = await ref.watch(feedUserInterestsProvider(feedType).future);
  final config = await ref.watch(feedConfigProvider.future);
  final random = Random();
  return FeedUserInterestPicker(config: config, interests: interests, random: random);
}
