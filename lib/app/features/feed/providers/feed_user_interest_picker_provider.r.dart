// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/feed_config.f.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.f.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_config_provider.r.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_user_interest_picker_provider.r.g.dart';

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

  /// Rolls a random category based on the user's interests and the configuration.
  ///
  /// Only the [allowedSubcategories] are considered, if provided.
  String? roll([List<String>? allowedCategories]) {
    final categories = _getAllowedCategories(allowedCategories);

    if (_roll(_config.notInterestedCategoryChance)) {
      // if rolled the scenario where we have to pick a parent category
      // the user is not interested in, we pick an entirely random category
      return _getRandomItem(categories.keys);
    }

    return _getRandomInterestedByWeight(categories)?.key;
  }

  bool _roll(double chance) => chance > _random.nextDouble();

  T? _getRandomItem<T>(Iterable<T> items) =>
      items.isEmpty ? null : items.elementAt(_random.nextInt(items.length));

  Map<String, FeedInterestsCategory> _getAllowedCategories([List<String>? allowedCategories]) {
    if (allowedCategories == null) return _interests.categories;

    final entries =
        _interests.categories.entries.where((entry) => allowedCategories.contains(entry.key));

    return Map.fromEntries(entries);
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

    if (totalInterestedWeight == 0) return _getRandomItem(node.entries);

    final roll = _random.nextInt(totalInterestedWeight);

    var sum = 0;
    for (var i = 0; i < interestedItems.length; i++) {
      sum += interestedItems[i].value.weight;
      if (roll < sum) {
        return interestedItems[i];
      }
    }

    return _getRandomItem(node.entries);
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
