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

  String getTitle(BuildContext context) {
    switch (this) {
      case UserCategoryType.aviation:
        return context.i18n.category_aviation;
      case UserCategoryType.blockchain:
        return context.i18n.category_blockchain;
      case UserCategoryType.business:
        return context.i18n.category_business;
      case UserCategoryType.cars:
        return context.i18n.category_cars;
      case UserCategoryType.cryptocurrency:
        return context.i18n.category_cryptocurrency;
      case UserCategoryType.dataScience:
        return context.i18n.category_data_science;
      case UserCategoryType.education:
        return context.i18n.category_education;
      case UserCategoryType.finance:
        return context.i18n.category_finance;
      case UserCategoryType.gamer:
        return context.i18n.category_gamer;
      case UserCategoryType.style:
        return context.i18n.category_style;
      case UserCategoryType.restaurant:
        return context.i18n.category_restaurant;
      case UserCategoryType.trading:
        return context.i18n.category_trading;
      case UserCategoryType.technology:
        return context.i18n.category_technology;
      case UserCategoryType.traveler:
        return context.i18n.category_traveler;
      case UserCategoryType.news:
        return context.i18n.category_news;
    }
  }
}
