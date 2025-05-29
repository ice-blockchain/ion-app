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
        _random = random;

  final FeedConfig _config;

  final FeedInterests _interests;

  final Random _random;

  String roll() {
    final categories = _interests.categories;

    if (_roll(_config.notInterestedCategoryChance)) {
      // if rolled the scenario where we have to pick a parent category
      // the user is not interested in, we pick an entirely random child
      // of an entirely random parent.
      final randomCategory = _getRandomItem(categories.values);
      return _getRandomItem(randomCategory.children.keys);
    }

    final interestedCategory = _getRandomInterestedByWeight(categories);

    if (_roll(_config.notInterestedSubcategoryChance)) {
      // If rolled the scenario where you have to pick a child category
      // the user is not interested in, we pick an entirely random child
      // of that parent.
      return _getRandomItem(interestedCategory.value.children.keys);
    }

    return _getRandomInterestedByWeight(interestedCategory.value.children).key;
  }

  bool _roll(double chance) => chance > _random.nextDouble();

  T _getRandomItem<T>(Iterable<T> items) => items.elementAt(_random.nextInt(items.length));

  /// Caches the results of the interested categories to avoid recalculating them
  /// every time we roll.
  ///
  /// Keyed by the hash code of the Map node, which remains the same over time.
  final Map<int, InterestedItems> _cache = {};

  /// Returns a list of interested items for the given node and sum of their weights.
  ///
  /// An item is considered "interesting" to the user if its weight
  /// is bigger than the threshold multiplied by the total weight of all sibling
  /// items under the same parent.
  InterestedItems<T>? _getInterested<T extends CategoryWithWeight>(Map<String, T> node) {
    if (_cache.containsKey(node.hashCode)) {
      return _cache[node.hashCode]! as InterestedItems<T>;
    }

    final entries = node.entries.toList();
    final totalWeight = entries.fold<int>(0, (sum, item) => sum + item.value.weight);

    if (totalWeight == 0) {
      return null;
    }

    final minInterestedWeight = _config.interestedThreshold * totalWeight;

    final interested = entries.where((item) => item.value.weight >= minInterestedWeight).toList();

    if (interested.isEmpty) {
      return null;
    }

    final interestedTotalWeight = interested.fold<int>(0, (sum, item) => sum + item.value.weight);

    return _cache[node.hashCode] = (items: interested, totalWeight: interestedTotalWeight);
  }

  /// Returns a random interested item from the given node.
  /// Weight is taken into account, so items with higher weight are more likely to be picked.
  ///
  /// For example, for a node with children [{weight: 1}, {weight: 3}],
  /// the first item has a 25% chance of being picked,
  /// while the second item has a 75% chance.
  MapEntry<String, T> _getRandomInterestedByWeight<T extends CategoryWithWeight>(
    Map<String, T> node,
  ) {
    final interested = _getInterested(node);

    if (interested == null) {
      return _getRandomItem(node.entries);
    }

    final (:items, :totalWeight) = interested;

    final roll = _random.nextInt(totalWeight);

    var sum = 0;
    for (var i = 0; i < items.length; i++) {
      sum += items[i].value.weight;
      if (roll < sum) {
        return items[i];
      }
    }

    return _getRandomItem(items);
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
