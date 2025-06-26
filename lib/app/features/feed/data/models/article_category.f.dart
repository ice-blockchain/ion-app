// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/generated/assets.gen.dart';

part 'article_category.f.freezed.dart';

@freezed
class ArticleCategory with _$ArticleCategory {
  const factory ArticleCategory({
    required String id,
    required String name,
    required String icon,
  }) = _ArticleCategory;
}

final List<ArticleCategory> mockedArticleCategories = [
  ArticleCategory(
    id: '1',
    name: 'Exchanges',
    icon: Assets.svg.iconBlockRepost,
  ),
  ArticleCategory(
    id: '2',
    name: 'Crypto',
    icon: Assets.svg.iconTabsCoins,
  ),
  ArticleCategory(
    id: '3',
    name: 'Game',
    icon: Assets.svg.iconCategoriesGame,
  ),
  ArticleCategory(
    id: '4',
    name: 'Business',
    icon: Assets.svg.iconCategoriesBusiness,
  ),
  ArticleCategory(
    id: '5',
    name: 'Travel',
    icon: Assets.svg.iconCategoriesTravel,
  ),
  ArticleCategory(
    id: '6',
    name: 'Programming',
    icon: Assets.svg.iconCategoriesProgramm,
  ),
  ArticleCategory(
    id: '7',
    name: 'AI',
    icon: Assets.svg.iconCategoriesAi,
  ),
  ArticleCategory(
    id: '8',
    name: 'Work',
    icon: Assets.svg.iconCategoriesBusiness,
  ),
  ArticleCategory(
    id: '9',
    name: 'Science',
    icon: Assets.svg.iconCategoriesScience,
  ),
];
