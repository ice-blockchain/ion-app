// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';

enum UserCategoryType {
  aviation,
  blockchain,
  business,
  cars,
  cryptocurrency,
  dataScience,
  education,
  finance,
  gamer,
  style,
  restaurant,
  trading,
  technology,
  traveler,
  news;

  String getTitle(BuildContext context) => switch (this) {
        UserCategoryType.aviation => context.i18n.category_aviation,
        UserCategoryType.blockchain => context.i18n.category_blockchain,
        UserCategoryType.business => context.i18n.category_business,
        UserCategoryType.cars => context.i18n.category_cars,
        UserCategoryType.cryptocurrency => context.i18n.category_cryptocurrency,
        UserCategoryType.dataScience => context.i18n.category_data_science,
        UserCategoryType.education => context.i18n.category_education,
        UserCategoryType.finance => context.i18n.category_finance,
        UserCategoryType.gamer => context.i18n.category_gamer,
        UserCategoryType.style => context.i18n.category_style,
        UserCategoryType.restaurant => context.i18n.category_restaurant,
        UserCategoryType.trading => context.i18n.category_trading,
        UserCategoryType.technology => context.i18n.category_technology,
        UserCategoryType.traveler => context.i18n.category_traveler,
        UserCategoryType.news => context.i18n.category_news,
      };
}
