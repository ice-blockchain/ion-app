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
      EmojiCategory.recent => Assets.svgIconChatRecentemoji,
      EmojiCategory.smileysPeople => Assets.svgIconChatSmileemoji,
      EmojiCategory.animalsNature => Assets.svgIconChatAnimalemoji,
      EmojiCategory.foodAndDrink => Assets.svgIconChatCupemoji,
      EmojiCategory.activities => Assets.svgIconChatSportemoji,
      EmojiCategory.travelAndPlaces => Assets.svgIconChartCaremoji,
      EmojiCategory.objects => Assets.svgIconChatBulb,
      EmojiCategory.symbols => Assets.svgIconChatTagemoji,
      EmojiCategory.flags => Assets.svgIconChatFlagemoji,
    };

    return icon;
  }
}
