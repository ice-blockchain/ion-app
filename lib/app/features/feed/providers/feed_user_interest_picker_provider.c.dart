import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
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
  })  : _config = config,
        _interests = interests;

  final FeedConfig _config;

  final FeedInterests _interests;

  String roll() {
    final categories = _interests.categories.entries.toList();

    if (_roll(_config.notInterestedCategoryChance)) {
      // if rolled the scenario where we have to pick a parent category
      // the user is not interested in, we pick an entirely random child
      // of an entirely random parent.
      final randomCategory = categories.random;
      return randomCategory.value.children.entries.toList().random.key;
    }

    final interestedCategory = _getRandomInterestedByWeight(categories);
    final interestedCategoryChildren = interestedCategory.value.children.entries.toList();

    if (_roll(_config.notInterestedSubcategoryChance)) {
      // If rolled the scenario where you have to pick a child category
      // the user is not interested in, we pick an entirely random child
      // of that parent.
      return interestedCategoryChildren.random.key;
    }

    return _getRandomInterestedByWeight(interestedCategoryChildren).key;
  }

  bool _roll(double chance) => chance > _random.nextDouble();

  T _getRandomInterestedByWeight<T extends MapEntry<String, CategoryWithWeight>>(List<T> items) {
    final totalWeight = items.fold<int>(0, (sum, category) => sum + category.value.weight);

    if (totalWeight == 0) {
      return items.random;
    }

    final interestedThreshold = _config.notInterestedThreshold * totalWeight;

    final interested = items.where((item) => item.value.weight > interestedThreshold).toList();

    if (interested.isEmpty) {
      return items.random;
    }

    final interestedTotalWeight = interested.fold<int>(0, (sum, item) => sum + item.value.weight);

    final roll = _random.nextInt(interestedTotalWeight);

    var sum = 0;
    for (var i = 0; i < interested.length; i++) {
      sum += interested[i].value.weight;
      if (roll < sum) {
        return interested[i];
      }
    }

    return interested.random;
  }

  static final _random = Random();
}

@riverpod
Future<FeedUserInterestPicker> feedUserInterestPicker(Ref ref, FeedType feedType) async {
  final interests = await ref.watch(feedUserInterestsProvider(feedType).future);
  final config = await ref.watch(feedConfigProvider.future);
  return FeedUserInterestPicker(config: config, interests: interests);
}
