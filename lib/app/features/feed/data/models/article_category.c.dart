// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/generated/assets.gen.dart';

part 'article_category.c.freezed.dart';

@freezed
class ArticleCategory with _$ArticleCategory {
  const factory ArticleCategory({
    required String id,
    required String name,
    required String icon,
  }) = _ArticleCategory;
}

final List<ArticleCategory> mockedArticleCategories = [
  const ArticleCategory(
    id: '1',
    name: 'Exchanges',
    icon: Assets.svgIconBlockRepost,
  ),
  const ArticleCategory(
    id: '2',
    name: 'Crypto',
    icon: Assets.svgIconTabsCoins,
  ),
  const ArticleCategory(
    id: '3',
    name: 'Game',
    icon: Assets.svgIconCategoriesGame,
  ),
  const ArticleCategory(
    id: '4',
    name: 'Business',
    icon: Assets.svgIconCategoriesBusiness,
  ),
  const ArticleCategory(
    id: '5',
    name: 'Travel',
    icon: Assets.svgIconCategoriesTravel,
  ),
  const ArticleCategory(
    id: '6',
    name: 'Programming',
    icon: Assets.svgIconCategoriesProgramm,
  ),
  const ArticleCategory(
    id: '7',
    name: 'AI',
    icon: Assets.svgIconCategoriesAi,
  ),
  const ArticleCategory(
    id: '8',
    name: 'Work',
    icon: Assets.svgIconCategoriesBusiness,
  ),
  const ArticleCategory(
    id: '9',
    name: 'Science',
    icon: Assets.svgIconCategoriesScience,
  ),
];
