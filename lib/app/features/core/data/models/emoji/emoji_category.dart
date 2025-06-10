// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum EmojiCategory {
  recent,
  smileysPeople,
  animalsNature,
  foodAndDrink,
  activities,
  travelAndPlaces,
  objects,
  symbols,
  flags;

  String getTitle(BuildContext context) {
    return switch (this) {
      EmojiCategory.recent => context.i18n.recent_emoji_reactions,
      EmojiCategory.smileysPeople => context.i18n.emoji_category_smileys_people,
      EmojiCategory.animalsNature => context.i18n.emoji_category_animals_nature,
      EmojiCategory.foodAndDrink => context.i18n.emoji_category_food_drink,
      EmojiCategory.activities => context.i18n.emoji_category_activities,
      EmojiCategory.travelAndPlaces => context.i18n.emoji_category_travel_places,
      EmojiCategory.objects => context.i18n.emoji_category_objects,
      EmojiCategory.symbols => context.i18n.emoji_category_symbols,
      EmojiCategory.flags => context.i18n.emoji_category_flags,
    };
  }

  static EmojiCategory fromSlug(String slug) {
    return switch (slug) {
      'recent' => EmojiCategory.recent,
      'smileys_people' => EmojiCategory.smileysPeople,
      'animals_nature' => EmojiCategory.animalsNature,
      'food_drink' => EmojiCategory.foodAndDrink,
      'activities' => EmojiCategory.activities,
      'travel_places' => EmojiCategory.travelAndPlaces,
      'objects' => EmojiCategory.objects,
      'symbols' => EmojiCategory.symbols,
      'flags' => EmojiCategory.flags,
      _ => EmojiCategory.recent,
    };
  }

  String getSlug() {
    return switch (this) {
      EmojiCategory.recent => 'recent',
      EmojiCategory.smileysPeople => 'smileys_people',
      EmojiCategory.animalsNature => 'animals_nature',
      EmojiCategory.foodAndDrink => 'food_drink',
      EmojiCategory.activities => 'activities',
      EmojiCategory.travelAndPlaces => 'travel_places',
      EmojiCategory.objects => 'objects',
      EmojiCategory.symbols => 'symbols',
      EmojiCategory.flags => 'flags',
    };
  }

  String getIcon(BuildContext context) {
    final icon = switch (this) {
      EmojiCategory.recent => Assets.svg.iconChatRecentemoji,
      EmojiCategory.smileysPeople => Assets.svg.iconChatSmileemoji,
      EmojiCategory.animalsNature => Assets.svg.iconChatAnimalemoji,
      EmojiCategory.foodAndDrink => Assets.svg.iconChatCupemoji,
      EmojiCategory.activities => Assets.svg.iconChatSportemoji,
      EmojiCategory.travelAndPlaces => Assets.svg.iconChartCaremoji,
      EmojiCategory.objects => Assets.svg.iconChatBulb,
      EmojiCategory.symbols => Assets.svg.iconChatTagemoji,
      EmojiCategory.flags => Assets.svg.iconChatFlagemoji,
    };

    return icon;
  }
}
