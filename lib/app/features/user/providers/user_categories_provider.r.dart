// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/model/user_category.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_categories_provider.r.g.dart';

// this will be final version of categories
// optimized for performance
const _userCategoryData = [
  UserCategory(key: 'aviation', name: 'Aviation'),
  UserCategory(key: 'blockchain', name: 'Blockchain'),
  UserCategory(key: 'business', name: 'Business'),
  UserCategory(key: 'cars', name: 'Cars'),
  UserCategory(key: 'cryptocurrency', name: 'Cryptocurrency'),
  UserCategory(key: 'dataScience', name: 'Data Science'),
  UserCategory(key: 'education', name: 'Education'),
  UserCategory(key: 'finance', name: 'Finance'),
  UserCategory(key: 'gamer', name: 'Gamer'),
  UserCategory(key: 'style', name: 'Style'),
  UserCategory(key: 'restaurant', name: 'Restaurant'),
  UserCategory(key: 'trading', name: 'Trading'),
  UserCategory(key: 'technology', name: 'Technology'),
  UserCategory(key: 'traveler', name: 'Traveler'),
  UserCategory(key: 'news', name: 'News'),
];

@riverpod
Map<String, UserCategory> userCategories(Ref ref) {
  return {for (final category in _userCategoryData) category.key: category};
}
